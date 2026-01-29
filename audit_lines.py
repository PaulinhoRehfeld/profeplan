import os

def count_lines(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            return sum(1 for _ in f)
    except Exception:
        return 0

def scan_dir(root_dir):
    results = []
    for root, dirs, files in os.walk(root_dir):
        if 'node_modules' in dirs:
            dirs.remove('node_modules')
        if '.git' in dirs:
            dirs.remove('.git')
        
        for file in files:
            if file.endswith(('.ts', '.tsx', '.js', '.jsx')):
                filepath = os.path.join(root, file)
                lines = count_lines(filepath)
                if lines > 150:
                    results.append((lines, filepath))
    
    results.sort(reverse=True)
    print("Files with > 150 lines:")
    for lines, filepath in results:
        print(f"{lines}\t{filepath}")

if __name__ == "__main__":
    scan_dir('src')
