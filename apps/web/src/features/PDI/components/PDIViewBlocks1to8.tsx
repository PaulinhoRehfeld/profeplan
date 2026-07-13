import React, { useEffect, useState } from 'react';
import {
  User,
  FileText,
  Target,
  Package,
  Users as UsersIcon,
  Calendar,
  Home,
  MessageSquare,
  Eye,
  Lock,
} from 'lucide-react';
import { PdiDocumentService } from '../../../services/pdi/PdiDocumentService';
import { Block1to8Data } from '../../../types/pdi';

interface PDIViewBlocks1to8Props {
  pdiId: string;
}

const PDIViewBlocks1to8: React.FC<PDIViewBlocks1to8Props> = ({ pdiId }) => {
  const [data, setData] = useState<Block1to8Data | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadData();
  }, [pdiId]);

  const loadData = async () => {
    setLoading(true);
    try {
      const { data: pdi } = await PdiDocumentService.getPdiDocument(pdiId);
      if (pdi && pdi.content_data) {
        const content = pdi.content_data;
        // Map new schema back to legacy state for UI compatibility
        const legacyData: any = {
          bloco_1_identificacao: content.student_data
            ? {
                nome_completo: content.student_data.name || '',
                data_nascimento: content.student_data.dob || '',
                serie: content.student_data.school_year || '',
                turma: content.student_data.class_name || '',
                turno: content.student_data.shift || '',
              }
            : {},
          bloco_2_diagnostico: content.clinical_health
            ? {
                laudo_medico: content.clinical_health.diagnosis_cid || '',
                restricoes_atividades: content.clinical_health.medical_updates || '',
                medicamentos_uso: content.clinical_health.medication || '',
              }
            : {},
          // Add other blocks as needed
        };
        setData(legacyData);
      }
    } catch (error) {
      console.error('Error loading PDI blocks 1-8:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-10 w-10 border-4 border-blue-600 border-t-transparent"></div>
      </div>
    );
  }

  if (!data) {
    return (
      <div className="text-center py-12">
        <p className="text-slate-600">Formulário base ainda não preenchido</p>
      </div>
    );
  }

  return (
    <div className="space-y-8">
      {/* Header Info */}
      <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4 flex items-start gap-3">
        <Lock size={20} className="text-yellow-700 shrink-0 mt-0.5" />
        <div className="text-sm text-yellow-900">
          <strong>Modo Visualização:</strong> Você pode visualizar estes dados, mas apenas o gestor
          escolar pode editá-los.
        </div>
      </div>

      {/* Block 1: Identificação */}
      <BlockSection
        icon={User}
        title="Bloco 1: Identificação do Aluno"
        color="bg-blue-100 text-blue-700"
      >
        <InfoRow label="Nome Completo" value={data.bloco_1_identificacao?.nome_completo} />
        <InfoRow label="Data de Nascimento" value={data.bloco_1_identificacao?.data_nascimento} />
        <InfoRow label="Código INEP" value={data.bloco_1_identificacao?.codigo_inep} />
        <InfoRow label="Série" value={data.bloco_1_identificacao?.serie} />
        <InfoRow label="Turma" value={data.bloco_1_identificacao?.turma} />
        <InfoRow label="Turno" value={data.bloco_1_identificacao?.turno} />
        <InfoRow
          label="Diagnóstico Clínico"
          value={data.bloco_1_identificacao?.diagnostico_clinico}
          multiline
        />
        <InfoRow label="Laudo Médico" value={data.bloco_1_identificacao?.laudo_medico} />
        <InfoRow label="Data do Laudo" value={data.bloco_1_identificacao?.data_laudo} />
      </BlockSection>

      {/* Block 2: Diagnóstico */}
      <BlockSection
        icon={FileText}
        title="Bloco 2: Diagnóstico Pedagógico"
        color="bg-emerald-100 text-emerald-700"
      >
        <InfoList
          label="Necessidades Específicas"
          items={data.bloco_2_diagnostico?.necessidades_especificas}
        />
        <InfoList
          label="Áreas Comprometidas"
          items={data.bloco_2_diagnostico?.areas_comprometidas}
        />
        <InfoList label="Potencialidades" items={data.bloco_2_diagnostico?.potencialidades} />
        <InfoList label="Desafios" items={data.bloco_2_diagnostico?.desafios} />
        <InfoRow
          label="Medicamentos em Uso"
          value={data.bloco_2_diagnostico?.medicamentos_uso}
          multiline
        />
        <InfoRow
          label="Restrições de Atividades"
          value={data.bloco_2_diagnostico?.restricoes_atividades}
          multiline
        />
      </BlockSection>

      {/* Block 3: Objetivos */}
      <BlockSection
        icon={Target}
        title="Bloco 3: Objetivos do PDI"
        color="bg-purple-100 text-purple-700"
      >
        <InfoRow label="Objetivo Geral" value={data.bloco_3_objetivos?.objetivo_geral} multiline />
        <InfoList
          label="Objetivos Específicos"
          items={data.bloco_3_objetivos?.objetivos_especificos}
        />
        <InfoList label="Metas de Curto Prazo" items={data.bloco_3_objetivos?.metas_curto_prazo} />
        <InfoList label="Metas de Longo Prazo" items={data.bloco_3_objetivos?.metas_longo_prazo} />
      </BlockSection>

      {/* Block 4: Recursos */}
      <BlockSection
        icon={Package}
        title="Bloco 4: Recursos e Materiais"
        color="bg-orange-100 text-orange-700"
      >
        <InfoList
          label="Recursos Tecnológicos"
          items={data.bloco_4_recursos?.recursos_tecnologicos}
        />
        <InfoList label="Materiais Adaptados" items={data.bloco_4_recursos?.materiais_adaptados} />
        <InfoRow
          label="Mobiliário Específico"
          value={data.bloco_4_recursos?.mobiliario_especifico}
          multiline
        />
        <InfoList label="Equipamentos" items={data.bloco_4_recursos?.equipamentos} />
      </BlockSection>

      {/* Block 5: Equipe */}
      <BlockSection
        icon={UsersIcon}
        title="Bloco 5: Equipe Multidisciplinar"
        color="bg-teal-100 text-teal-700"
      >
        <InfoList label="Professores Envolvidos" items={data.bloco_5_equipe?.professores} />
        <InfoRow label="Apoio Escolar" value={data.bloco_5_equipe?.apoio_escolar} multiline />
        {data.bloco_5_equipe?.equipe_multidisciplinar &&
          data.bloco_5_equipe.equipe_multidisciplinar.length > 0 && (
            <div>
              <label className="block text-sm font-bold text-slate-700 mb-2">
                Equipe Multidisciplinar
              </label>
              <div className="space-y-2">
                {data.bloco_5_equipe.equipe_multidisciplinar.map((membro, index) => (
                  <div key={index} className="bg-slate-50 p-3 rounded-lg">
                    <p className="font-semibold text-slate-900">{membro.nome}</p>
                    <p className="text-sm text-slate-600">{membro.funcao}</p>
                    {membro.contato && <p className="text-sm text-slate-500">{membro.contato}</p>}
                  </div>
                ))}
              </div>
            </div>
          )}
      </BlockSection>

      {/* Block 6: Atendimento */}
      <BlockSection
        icon={Calendar}
        title="Bloco 6: Plano de Atendimento"
        color="bg-pink-100 text-pink-700"
      >
        <InfoRow
          label="Frequência de Atendimento"
          value={data.bloco_6_atendimento?.frequencia_atendimento}
        />
        <InfoRow label="Horários" value={data.bloco_6_atendimento?.horarios} />
        <InfoRow label="Local" value={data.bloco_6_atendimento?.local} />
        <InfoList label="Responsáveis" items={data.bloco_6_atendimento?.responsaveis} />
        <InfoList label="Tipo de Atendimento" items={data.bloco_6_atendimento?.tipo_atendimento} />
      </BlockSection>

      {/* Block 7: Família */}
      <BlockSection
        icon={Home}
        title="Bloco 7: Participação da Família"
        color="bg-indigo-100 text-indigo-700"
      >
        <InfoRow
          label="Responsável Principal"
          value={data.bloco_7_familia?.responsavel_principal}
        />
        <InfoRow label="Contato do Responsável" value={data.bloco_7_familia?.contato_responsavel} />
        <InfoRow
          label="Participação da Família"
          value={data.bloco_7_familia?.participacao_familia}
          multiline
        />
        <InfoRow
          label="Orientações para a Família"
          value={data.bloco_7_familia?.orientacoes_familia}
          multiline
        />
      </BlockSection>

      {/* Block 8: Observações */}
      <BlockSection
        icon={MessageSquare}
        title="Bloco 8: Observações Gerais"
        color="bg-slate-100 text-slate-700"
      >
        <InfoRow
          label="Observações Gerais"
          value={data.bloco_8_observacoes?.observacoes_gerais}
          multiline
        />
        <InfoRow
          label="Histórico Escolar"
          value={data.bloco_8_observacoes?.historico_escolar}
          multiline
        />
        <InfoRow
          label="Transferências"
          value={data.bloco_8_observacoes?.transferencias}
          multiline
        />
        <InfoRow
          label="Outras Informações"
          value={data.bloco_8_observacoes?.outras_informacoes}
          multiline
        />
      </BlockSection>
    </div>
  );
};

// ============================================================================
// HELPER COMPONENTS
// ============================================================================

const BlockSection: React.FC<{
  icon: any;
  title: string;
  color: string;
  children: React.ReactNode;
}> = ({ icon: Icon, title, color, children }) => (
  <div className="bg-white rounded-2xl border border-slate-200 overflow-hidden">
    <div className={`${color} px-6 py-4 flex items-center gap-3`}>
      <Icon size={24} />
      <h3 className="text-lg font-bold">{title}</h3>
    </div>
    <div className="p-6 space-y-4">{children}</div>
  </div>
);

const InfoRow: React.FC<{
  label: string;
  value?: string;
  multiline?: boolean;
}> = ({ label, value, multiline }) => {
  if (!value) return null;

  return (
    <div>
      <label className="block text-sm font-bold text-slate-700 mb-1">{label}</label>
      {multiline ? (
        <div className="bg-slate-50 p-3 rounded-lg text-slate-900 whitespace-pre-wrap">{value}</div>
      ) : (
        <p className="text-slate-900">{value}</p>
      )}
    </div>
  );
};

const InfoList: React.FC<{
  label: string;
  items?: string[];
}> = ({ label, items }) => {
  if (!items || items.length === 0) return null;

  return (
    <div>
      <label className="block text-sm font-bold text-slate-700 mb-2">{label}</label>
      <ul className="space-y-1.5">
        {items.map((item, index) => (
          <li key={index} className="flex items-start gap-2">
            <span className="w-1.5 h-1.5 bg-slate-400 rounded-full mt-2 shrink-0"></span>
            <span className="text-slate-900">{item}</span>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default PDIViewBlocks1to8;
