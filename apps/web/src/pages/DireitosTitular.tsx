import React from 'react';
import { LegalLayout } from '../components/LegalLayout';

const DireitosTitular: React.FC = () => (
  <LegalLayout title="Direitos do Titular e Canal de Privacidade">
    <section>
      <h2>Seus direitos</h2>
      <p>
        A <strong>WR TECH INOVA SIMPLES (I.S.)</strong>, responsável pelo ProfePlan, mantém um canal
        para solicitações relacionadas a dados pessoais.
      </p>
      <p>O titular poderá solicitar:</p>
      <ul>
        <li>confirmação da existência de tratamento;</li>
        <li>acesso aos dados;</li>
        <li>correção;</li>
        <li>atualização;</li>
        <li>anonimização;</li>
        <li>bloqueio;</li>
        <li>eliminação;</li>
        <li>portabilidade, quando aplicável;</li>
        <li>informações sobre compartilhamento;</li>
        <li>revogação de consentimento;</li>
        <li>oposição ao tratamento;</li>
        <li>revisão de decisão automatizada, quando aplicável.</li>
      </ul>
    </section>

    <section>
      <h2>Como solicitar</h2>
      <p>
        Enviar e-mail para:{' '}
        <a href="mailto:suporte@profeplan.com.br">suporte@profeplan.com.br</a>
      </p>
      <p><strong>Assunto sugerido:</strong> Solicitação LGPD — [tipo da solicitação]</p>
      <p><strong>Informar:</strong></p>
      <ul>
        <li>nome completo;</li>
        <li>e-mail utilizado no ProfePlan;</li>
        <li>descrição da solicitação;</li>
        <li>relação com os dados;</li>
        <li>informações necessárias para localização do cadastro.</li>
      </ul>
      <p>
        Não é necessário enviar cópia completa de documento pessoal por padrão. A verificação será
        proporcional ao risco.
      </p>
    </section>

    <section>
      <h2>Prazo</h2>
      <p>
        A solicitação será analisada e respondida dentro dos prazos previstos na legislação e nas
        normas aplicáveis.
      </p>
    </section>

    <section>
      <h2>Segurança</h2>
      <p>
        A empresa poderá solicitar confirmação de identidade para impedir que dados sejam entregues
        a pessoas não autorizadas.
      </p>
    </section>

    <section>
      <h2>Solicitações relativas a estudantes</h2>
      <p>
        Quando a solicitação envolver dados inseridos por uma escola ou professor, poderá ser
        necessário envolver a instituição responsável.
      </p>
      <p>O melhor interesse da criança ou adolescente deverá ser priorizado.</p>
    </section>

    <section>
      <h2>Contato da empresa</h2>
      <p>
        <strong>WR TECH INOVA SIMPLES (I.S.)</strong>
        <br />
        CNPJ 65.458.067/0001-10
      </p>
      <p><a href="mailto:suporte@profeplan.com.br">suporte@profeplan.com.br</a></p>
    </section>
  </LegalLayout>
);

export default DireitosTitular;
