
import React, { useState, useEffect } from 'react';
import { Folder, FileText, HardDrive, Search, Download, Trash2, CloudCheck, UserCheck } from 'lucide-react';
import { DriveFile, DriveFolder } from '../types';

interface DriveExplorerProps {
  userEmail: string;
}

const DriveExplorer: React.FC<DriveExplorerProps> = ({ userEmail }) => {
  const [activeFolder, setActiveFolder] = useState<string | null>(null);
  const [driveData, setDriveData] = useState<DriveFolder[]>([]);

  useEffect(() => {
    const savedFilesRaw = localStorage.getItem(`profeplan_drive_${userEmail}`);
    const savedFiles: DriveFile[] = savedFilesRaw ? JSON.parse(savedFilesRaw) : [];

    setDriveData([
      { id: 'PLANOS', name: 'PLANOS', files: savedFiles.filter(f => f.name.includes('Plano')) },
      { id: 'AULAS', name: 'AULAS', files: savedFiles.filter(f => f.name.includes('Aula') || f.name.includes('Sequência')) },
      { id: 'AVALIAÇÕES', name: 'AVALIAÇÕES', files: savedFiles.filter(f => f.name.includes('Avaliacao')) },
      { id: 'OUTROS', name: 'OUTROS', files: savedFiles.filter(f => !f.name.includes('Plano') && !f.name.includes('Aula') && !f.name.includes('Avaliacao')) },
    ]);
  }, [userEmail]);

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      <div className="bg-slate-900 p-8 rounded-[40px] text-white flex flex-col md:flex-row justify-between items-center gap-6">
        <div>
          <h1 className="text-3xl font-black">Meu Workspace MG-EDU</h1>
          <p className="text-slate-400">Sincronizado com {userEmail}</p>
        </div>
        <div className="bg-white/10 p-4 rounded-3xl flex items-center gap-4">
          <HardDrive className="text-blue-400" />
          <div>
            <p className="text-[10px] uppercase font-bold text-slate-400">Armazenamento Cloud</p>
            <p className="text-lg font-bold">Pasta PROFEPLAN/</p>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {driveData.map((folder) => (
          <button
            key={folder.id}
            onClick={() => setActiveFolder(folder.id)}
            className={`p-6 rounded-[32px] border-2 transition-all text-left ${
              activeFolder === folder.id ? 'bg-blue-600 border-blue-400 text-white' : 'bg-white border-slate-100'
            }`}
          >
            <Folder className="w-8 h-8 mb-4" />
            <p className="font-bold">{folder.name}</p>
            <p className="text-xs opacity-60">{folder.files.length} itens</p>
          </button>
        ))}
      </div>

      <div className="bg-white rounded-[40px] border border-slate-200 overflow-hidden shadow-xl">
        <table className="w-full text-left">
          <thead className="bg-slate-50 text-[10px] font-bold text-slate-400 uppercase tracking-widest">
            <tr>
              <th className="px-8 py-4">Arquivo</th>
              <th className="px-8 py-4">Sincronizado</th>
              <th className="px-8 py-4 text-right">Ações</th>
            </tr>
          </thead>
          <tbody>
            {activeFolder && driveData.find(f => f.id === activeFolder)?.files.map(file => (
              <tr key={file.id} className="border-t border-slate-100 hover:bg-slate-50 transition-colors">
                <td className="px-8 py-4 font-bold text-sm flex items-center gap-3">
                  <FileText className="text-blue-500" /> {file.name}
                </td>
                <td className="px-8 py-4 text-xs text-slate-500">{new Date(file.createdAt).toLocaleDateString()}</td>
                <td className="px-8 py-4 text-right">
                  <button className="p-2 text-slate-400 hover:text-blue-600"><Download className="w-4 h-4" /></button>
                </td>
              </tr>
            )) || <tr><td colSpan={3} className="p-20 text-center text-slate-400">Selecione uma pasta para ver os arquivos</td></tr>}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default DriveExplorer;
