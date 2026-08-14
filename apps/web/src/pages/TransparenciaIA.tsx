import React from 'react';
import { LegalLayout } from '../components/LegalLayout';

const TransparenciaIA: React.FC = () => (
  <LegalLayout title="Transparência em Inteligência Artificial">
    <section>
      <p>O ProfePlan utiliza inteligência artificial como ferramenta de apoio ao professor.</p>
      <p>A inteligência artificial pode auxiliar na criação de:</p>
      <ul>
        <li>planejamentos;</li>
        <li>atividades;</li>
        <li>avaliações;</li>
        <li>sequências didáticas;</li>
        <li>apresentações;</li>
        <li>adaptações;</li>
        <li>materiais pedagógicos.</li>
      </ul>

      <h2>Limitações importantes</h2>
      <p>
        A inteligência artificial <strong>não substitui o professor</strong>.
      </p>
      <p>As respostas poderão apresentar erros, vieses ou limitações.</p>
      <p>
        <strong>Todo conteúdo deverá ser revisado</strong> antes de ser utilizado.
      </p>

      <h2>Usos não recomendados</h2>
      <p>O ProfePlan não deve ser utilizado para:</p>
      <ul>
        <li>diagnosticar estudantes;</li>
        <li>classificar definitivamente capacidades;</li>
        <li>aplicar sanções;</li>
        <li>decidir aprovação ou reprovação;</li>
        <li>produzir discriminação;</li>
        <li>substituir avaliação profissional;</li>
        <li>tomar decisões automáticas prejudiciais.</li>
      </ul>

      <h2>Boas práticas com dados de estudantes</h2>
      <p>
        Sempre que dados de estudantes forem necessários, devem ser minimizados e preferencialmente
        pseudonimizados.
      </p>

      <h2>Nosso compromisso de transparência</h2>
      <p>
        Não utilizamos expressões enganosas como "IA sem erros", "IA livre de vieses", "resultados
        garantidos", "precisão total" ou "substituição do trabalho docente".
      </p>
      <p>
        A inteligência artificial é uma ferramenta poderosa de apoio, mas a decisão pedagógica final
        pertence ao profissional de educação.
      </p>
    </section>
  </LegalLayout>
);

export default TransparenciaIA;
