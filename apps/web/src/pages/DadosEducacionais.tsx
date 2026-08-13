import React from 'react';
import { LegalLayout } from '../components/LegalLayout';

const DadosEducacionais: React.FC = () => (
  <LegalLayout title="Aviso de Privacidade para Dados Educacionais">
    <section>
      <h2>1. Finalidade</h2>
      <p>
        Este aviso explica os cuidados relacionados a informações de estudantes inseridas no
        ProfePlan por professores, gestores ou instituições.
      </p>
    </section>

    <section>
      <h2>2. Princípio da minimização</h2>
      <p>Insira somente informações necessárias para a finalidade pedagógica.</p>
      <p>Sempre que possível, utilize:</p>
      <ul>
        <li>iniciais;</li>
        <li>pseudônimos;</li>
        <li>códigos;</li>
        <li>identificação interna;</li>
        <li>descrição sem identificação direta.</li>
      </ul>
    </section>

    <section>
      <h2>3. Informações que devem ser evitadas</h2>
      <p>Evite inserir, salvo necessidade legítima e autorização adequada:</p>
      <ul>
        <li>CPF;</li>
        <li>RG;</li>
        <li>endereço residencial;</li>
        <li>telefone pessoal;</li>
        <li>documentos;</li>
        <li>fotografias;</li>
        <li>biometria;</li>
        <li>dados financeiros;</li>
        <li>prontuários;</li>
        <li>laudos completos;</li>
        <li>histórico médico extenso;</li>
        <li>informações familiares sem finalidade pedagógica.</li>
      </ul>
    </section>

    <section>
      <h2>4. PDI e inclusão</h2>
      <p>Informações relacionadas a PDI e inclusão devem ser tratadas com cuidado reforçado.</p>
      <p>
        O ProfePlan apoia a elaboração pedagógica, mas não realiza diagnóstico médico ou
        psicológico.
      </p>
    </section>

    <section>
      <h2>5. Responsabilidade da instituição e do usuário</h2>
      <p>Professores e instituições devem:</p>
      <ul>
        <li>respeitar normas internas;</li>
        <li>verificar a base legal;</li>
        <li>controlar acessos;</li>
        <li>evitar exposição;</li>
        <li>manter sigilo;</li>
        <li>excluir dados desnecessários;</li>
        <li>revisar materiais gerados.</li>
      </ul>
    </section>

    <section>
      <h2>6. Inteligência artificial</h2>
      <p>Antes de enviar informações a ferramentas de inteligência artificial:</p>
      <ul>
        <li>remover dados identificadores desnecessários;</li>
        <li>evitar nome completo;</li>
        <li>utilizar descrição pedagógica objetiva;</li>
        <li>não enviar documentos clínicos completos;</li>
        <li>revisar a resposta humana e pedagogicamente.</li>
      </ul>
    </section>

    <section>
      <h2>7. Direitos</h2>
      <p>
        Pais, responsáveis, estudantes e instituições poderão solicitar informações ou providências
        pelo canal: <a href="mailto:suporte@profeplan.com.br">suporte@profeplan.com.br</a>
      </p>
    </section>

    <section>
      <h2>8. Uso direto por crianças</h2>
      <p>O ProfePlan não é destinado, nesta versão, à criação direta de contas por crianças.</p>
      <p>
        Se futuramente forem criadas contas ou experiências diretamente voltadas a estudantes,
        deverá ser realizada nova avaliação jurídica, técnica e de produto antes da disponibilização.
      </p>
    </section>
  </LegalLayout>
);

export default DadosEducacionais;
