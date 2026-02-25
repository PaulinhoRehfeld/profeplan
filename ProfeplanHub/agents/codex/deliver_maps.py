import os
import shutil
import json
import time

def deliver_codex_maps():
    # Paths
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    SOURCE_DIR = os.path.join(BASE_DIR, "outputs", "codex_maps")
    
    # Destination is outside CODEX, in the PROFEPLAN root under 'ingest_data'
    # Assuming CODEX is at c:\Users\Admin\PROFEPLAN\CODEX
    PROFEPLAN_ROOT = os.path.dirname(BASE_DIR) 
    DEST_DIR = os.path.join(PROFEPLAN_ROOT, "ingest_data")

    print(f"--- CODEX DELIVERY SYSTEM ---")
    print(f"Source: {SOURCE_DIR}")
    print(f"Dest  : {DEST_DIR}")

    if not os.path.exists(SOURCE_DIR):
        print(f"[ERRO] Source directory not found: {SOURCE_DIR}")
        return

    # Create Dest
    if not os.path.exists(DEST_DIR):
        print(f"Creating destination directory...")
        os.makedirs(DEST_DIR)

    # Collect files
    delivered_files = []
    print("\nScanning for maps...")
    
    for root, dirs, files in os.walk(SOURCE_DIR):
        for file in files:
            if file.endswith(".json"):
                src_path = os.path.join(root, file)
                # We flatten the structure for ingestion
                dest_path = os.path.join(DEST_DIR, file)
                
                shutil.copy2(src_path, dest_path)
                delivered_files.append(file)
                print(f" -> Copied: {file}")

    if not delivered_files:
        print("[AVISO] No JSON maps found to deliver.")
        return

    # Generate Manifest
    manifest = {
        "source": "CODEX_INDEXER",
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
        "file_count": len(delivered_files),
        "files": delivered_files
    }
    
    manifest_path = os.path.join(DEST_DIR, "CODEX_MANIFEST.json")
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)
    print(f"\nManifest created: {manifest_path}")

    # Create Trigger File
    trigger_path = os.path.join(DEST_DIR, "READY_FOR_PROFEPLAN.trigger")
    with open(trigger_path, "w") as f:
        f.write("READY")
    print(f"Trigger created: {trigger_path}")
    
    print(f"\n[SUCCESS] Delivery Complete! {len(delivered_files)} maps sent.")

if __name__ == "__main__":
    deliver_codex_maps()
