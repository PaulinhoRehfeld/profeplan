import React from 'react';
import { Link } from 'react-router-dom';
import { LegalLayout } from '../components/LegalLayout';

const PoliticaPrivacidade: React.FC = () => (
  <LegalLayout
    title="Política de Privacidade do ProfePlan"
    subtitle="Saiba como coletamos, utilizamos, armazenamos, compartilhamos e protegemos dados pessoais durante o uso do site e da plataforma ProfePlan."
  >
    <section>
      <h2>1. Apresentação</h2>
      <p>A proteção da privacidade e dos dados pessoais faz parte dos compromissos do ProfePlan.</p>
      <p>
        Esta Política de Privacidade explica como os dados pessoais podem ser tratados durante o
        acesso à landing page, a criação de uma conta, a utilização da plataforma, a contratação de
        planos, o contato com o suporte e o uso das ferramentas pedagógicas e de inteligência
        artificial disponibilizadas pelo ProfePlan.
      </p>
      <p>
        O ProfePlan é um produto digital desenvolvido e operado por{' '}
        <strong>WR TECH INOVA SIMPLES (I.S.)</strong>, inscrita no CNPJ sob o nº{' '}
        <strong>65.458.067/0001-10</strong>, com sede na Rua Varginha, nº 92, Bairro Planalto,
        Capelinha, Minas Gerais, CEP 39682-036, Brasil.
      </p>
      <p>
        Para assuntos relacionados à privacidade e à proteção de dados, o contato deverá ser
        realizado pelo e-mail <a href="mailto:suporte@profeplan.com.br">suporte@profeplan.com.br</a>
        .
      </p>
    </section>

    <section>
      <h2>2. A quem esta política se aplica</h2>
      <p>Esta política se aplica a:</p>
      <ul>
        <li>visitantes da landing page;</li>
        <li>pessoas que preenchem formulários;</li>
        <li>professores;</li>
        <li>gestores escolares;</li>
        <li>profissionais da educação;</li>
        <li>assinantes;</li>
        <li>usuários de planos gratuitos;</li>
        <li>representantes de instituições de ensino;</li>
        <li>pessoas que entram em contato com o suporte;</li>
        <li>titulares cujos dados tenham sido inseridos na plataforma por usuários autorizados.</li>
      </ul>
      <p>
        A plataforma é direcionada principalmente a professores, gestores e outros profissionais
        adultos da educação.
      </p>
      <p>
        Nesta versão do produto, o ProfePlan não é apresentado como uma plataforma destinada à
        criação direta de contas por crianças ou adolescentes.
      </p>
    </section>

    <section>
      <h2>3. Papéis no tratamento de dados</h2>
      <p>
        A <strong>WR TECH INOVA SIMPLES (I.S.)</strong> atua como controladora dos dados pessoais
        relacionados a:
      </p>
      <ul>
        <li>visitantes da landing page;</li>
        <li>contatos comerciais;</li>
        <li>cadastros de usuários;</li>
        <li>autenticação;</li>
        <li>assinatura;</li>
        <li>cobrança;</li>
        <li>suporte;</li>
        <li>segurança;</li>
        <li>comunicações institucionais;</li>
        <li>administração da plataforma.</li>
      </ul>
      <p>
        Quando professores ou instituições inserem dados educacionais de estudantes, a definição dos
        papéis dependerá do contexto de utilização.
      </p>
      <p>
        Em contratações institucionais, a escola, rede de ensino ou instituição contratante poderá
        atuar como controladora dos dados educacionais, enquanto a WR TECH INOVA SIMPLES (I.S.)
        poderá atuar como operadora, tratando os dados conforme as instruções da instituição e os
        contratos aplicáveis.
      </p>
      <p>
        No uso individual, o usuário deve possuir autorização, competência profissional ou outra
        base legal válida para inserir informações de terceiros na plataforma.
      </p>
    </section>

    <section>
      <h2>4. Dados que poderão ser tratados</h2>

      <h3>4.1. Dados de navegação</h3>
      <p>Durante o acesso ao site, poderão ser tratados:</p>
      <ul>
        <li>endereço IP;</li>
        <li>data e horário de acesso;</li>
        <li>navegador;</li>
        <li>sistema operacional;</li>
        <li>tipo de dispositivo;</li>
        <li>páginas acessadas;</li>
        <li>origem da navegação;</li>
        <li>registros técnicos;</li>
        <li>eventos de segurança;</li>
        <li>identificadores de sessão;</li>
        <li>preferências de cookies.</li>
      </ul>

      <h3>4.2. Dados de contato</h3>
      <p>Quando uma pessoa preenche um formulário ou entra em contato, poderão ser tratados:</p>
      <ul>
        <li>nome;</li>
        <li>e-mail;</li>
        <li>telefone, quando fornecido;</li>
        <li>instituição de ensino;</li>
        <li>cargo ou função;</li>
        <li>cidade e estado;</li>
        <li>conteúdo da mensagem;</li>
        <li>histórico de atendimento.</li>
      </ul>

      <h3>4.3. Dados de cadastro e conta</h3>
      <p>Para criação e utilização da conta, poderão ser tratados:</p>
      <ul>
        <li>nome;</li>
        <li>e-mail;</li>
        <li>
          senha armazenada de forma protegida ou credencial gerenciada pelo provedor de
          autenticação;
        </li>
        <li>perfil profissional;</li>
        <li>instituição;</li>
        <li>disciplinas;</li>
        <li>etapas e modalidades de ensino;</li>
        <li>preferências pedagógicas;</li>
        <li>plano contratado;</li>
        <li>status da assinatura;</li>
        <li>registros de login;</li>
        <li>configurações da conta.</li>
      </ul>
      <p>A senha não deve ser armazenada em texto simples.</p>

      <h3>4.4. Dados de utilização da plataforma</h3>
      <p>Durante o uso do ProfePlan, poderão ser tratados:</p>
      <ul>
        <li>planejamentos;</li>
        <li>planos de aula;</li>
        <li>sequências didáticas;</li>
        <li>avaliações;</li>
        <li>atividades;</li>
        <li>materiais enviados;</li>
        <li>arquivos;</li>
        <li>comandos encaminhados às ferramentas de inteligência artificial;</li>
        <li>respostas geradas;</li>
        <li>preferências;</li>
        <li>histórico de uso;</li>
        <li>interações com funcionalidades;</li>
        <li>registros técnicos e de auditoria.</li>
      </ul>

      <h3>4.5. Dados de pagamento</h3>
      <p>Quando houver contratação de plano pago, poderão ser tratados:</p>
      <ul>
        <li>nome do titular;</li>
        <li>e-mail de cobrança;</li>
        <li>CPF ou CNPJ, quando necessário;</li>
        <li>endereço de cobrança;</li>
        <li>plano adquirido;</li>
        <li>valor;</li>
        <li>periodicidade;</li>
        <li>situação do pagamento;</li>
        <li>identificadores da transação;</li>
        <li>informações necessárias para emissão de documentos fiscais.</li>
      </ul>
      <p>
        Os dados completos do cartão devem ser processados pelo provedor de pagamentos utilizado
        pela plataforma.
      </p>
      <p>
        O ProfePlan não deve armazenar o número completo do cartão, o código de segurança ou
        credenciais bancárias completas em seu próprio banco de dados.
      </p>

      <h3>4.6. Dados educacionais de terceiros</h3>
      <p>Dependendo da funcionalidade utilizada, professores e instituições poderão inserir:</p>
      <ul>
        <li>nome ou identificação de estudante;</li>
        <li>turma;</li>
        <li>série;</li>
        <li>ano escolar;</li>
        <li>desempenho acadêmico;</li>
        <li>necessidades pedagógicas;</li>
        <li>adaptações;</li>
        <li>observações educacionais;</li>
        <li>informações relacionadas a planos de desenvolvimento individual;</li>
        <li>dados necessários para personalização pedagógica.</li>
      </ul>
      <p>
        Os usuários devem priorizar o uso de iniciais, códigos internos, pseudônimos ou outras
        formas de identificação reduzida sempre que o nome completo não for indispensável.
      </p>

      <h3>4.7. Dados pessoais sensíveis</h3>
      <p>
        Algumas informações educacionais poderão revelar dados sensíveis, principalmente quando
        relacionadas a:
      </p>
      <ul>
        <li>saúde;</li>
        <li>deficiência;</li>
        <li>condições de desenvolvimento;</li>
        <li>necessidades educacionais específicas;</li>
        <li>avaliações psicológicas;</li>
        <li>laudos;</li>
        <li>informações biométricas;</li>
        <li>origem racial ou étnica;</li>
        <li>convicções religiosas;</li>
        <li>outras categorias protegidas pela legislação.</li>
      </ul>
      <p>
        Esses dados somente devem ser inseridos quando forem estritamente necessários, adequados à
        finalidade pedagógica e amparados por base legal válida.
      </p>
      <p>
        O ProfePlan não deve ser utilizado como repositório indiscriminado de prontuários, laudos
        médicos ou documentos clínicos completos.
      </p>
    </section>

    <section>
      <h2>5. Para quais finalidades utilizamos os dados</h2>
      <p>Os dados poderão ser utilizados para:</p>
      <ul>
        <li>disponibilizar a landing page;</li>
        <li>responder a contatos;</li>
        <li>criar e administrar contas;</li>
        <li>autenticar usuários;</li>
        <li>fornecer funcionalidades pedagógicas;</li>
        <li>gerar conteúdos solicitados;</li>
        <li>personalizar a experiência do professor;</li>
        <li>prestar suporte;</li>
        <li>administrar assinaturas;</li>
        <li>processar pagamentos;</li>
        <li>prevenir fraudes;</li>
        <li>proteger a plataforma;</li>
        <li>corrigir erros;</li>
        <li>melhorar funcionalidades;</li>
        <li>produzir métricas técnicas;</li>
        <li>cumprir obrigações legais;</li>
        <li>exercer direitos em processos;</li>
        <li>enviar comunicações operacionais;</li>
        <li>enviar comunicações de marketing quando existir base legal adequada;</li>
        <li>proteger os direitos dos usuários e da empresa.</li>
      </ul>
    </section>

    <section>
      <h2>6. Bases legais</h2>
      <p>
        Conforme a finalidade e a categoria dos dados, o tratamento poderá estar fundamentado em:
      </p>
      <ul>
        <li>execução de contrato ou procedimentos preliminares;</li>
        <li>cumprimento de obrigação legal ou regulatória;</li>
        <li>exercício regular de direitos;</li>
        <li>legítimo interesse, mediante avaliação de necessidade e proporcionalidade;</li>
        <li>consentimento;</li>
        <li>proteção do crédito, quando aplicável;</li>
        <li>prevenção de fraudes e segurança;</li>
        <li>demais hipóteses previstas na legislação.</li>
      </ul>
      <p>Para dados pessoais sensíveis, serão observadas as bases legais específicas aplicáveis.</p>
      <p>
        No tratamento de dados de crianças e adolescentes, deverá prevalecer o seu melhor interesse.
      </p>
      <p>
        A Política de Privacidade não deve ser utilizada como uma autorização genérica para qualquer
        tratamento.
      </p>
      <p>
        Quando o consentimento for realmente necessário, ele deverá ser solicitado de forma
        específica, destacada, livre e informada.
      </p>
    </section>

    <section>
      <h2>7. Inteligência artificial</h2>
      <p>
        O ProfePlan utiliza ou poderá utilizar sistemas de inteligência artificial para auxiliar na
        produção de planejamentos, atividades, avaliações, apresentações, adaptações e outros
        materiais pedagógicos.
      </p>
      <p>As respostas produzidas por inteligência artificial podem conter:</p>
      <ul>
        <li>erros;</li>
        <li>informações incompletas;</li>
        <li>inadequações;</li>
        <li>vieses;</li>
        <li>referências incorretas;</li>
        <li>conteúdos desatualizados;</li>
        <li>interpretações imprecisas.</li>
      </ul>
      <p>O conteúdo gerado deve ser revisado pelo professor antes de ser utilizado.</p>
      <p>A inteligência artificial não substitui:</p>
      <ul>
        <li>a decisão pedagógica;</li>
        <li>a avaliação profissional;</li>
        <li>a responsabilidade do professor;</li>
        <li>o acompanhamento da escola;</li>
        <li>diagnóstico médico;</li>
        <li>avaliação psicológica;</li>
        <li>decisão administrativa;</li>
        <li>orientação jurídica.</li>
      </ul>
      <p>O ProfePlan não deve ser apresentado como sistema autônomo de decisão sobre estudantes.</p>
    </section>

    <section>
      <h2>8. Compartilhamento de dados</h2>
      <p>
        Os dados poderão ser compartilhados, dentro dos limites necessários, com categorias de
        fornecedores como:
      </p>
      <ul>
        <li>hospedagem e infraestrutura;</li>
        <li>banco de dados;</li>
        <li>autenticação;</li>
        <li>armazenamento;</li>
        <li>envio de e-mails;</li>
        <li>atendimento;</li>
        <li>processamento de pagamentos;</li>
        <li>prevenção de fraudes;</li>
        <li>monitoramento técnico;</li>
        <li>inteligência artificial;</li>
        <li>analytics, quando autorizado;</li>
        <li>contabilidade;</li>
        <li>assessoria jurídica;</li>
        <li>autoridades públicas, quando houver obrigação legal.</li>
      </ul>
      <p>
        <strong>Fornecedores identificados nesta versão:</strong>
      </p>
      <div style={{ overflowX: 'auto' }}>
        <table>
          <thead>
            <tr>
              <th>Fornecedor</th>
              <th>Finalidade</th>
              <th>Categoria de Dados</th>
              <th>Região</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Vercel</td>
              <td>Hospedagem e CDN</td>
              <td>Navegação, sessão</td>
              <td>Global (Edge: GRU1)</td>
            </tr>
            <tr>
              <td>Supabase</td>
              <td>Banco de dados e autenticação</td>
              <td>Cadastro, perfil, conteúdo</td>
              <td>Brasil / Global</td>
            </tr>
            <tr>
              <td>Azure OpenAI</td>
              <td>Inteligência artificial</td>
              <td>Comandos, conteúdo pedagógico</td>
              <td>Brasil / Global</td>
            </tr>
            <tr>
              <td>Stripe</td>
              <td>Processamento de pagamentos</td>
              <td>Transação, cobrança</td>
              <td>Global</td>
            </tr>
            <tr>
              <td>Resend / Titan Email</td>
              <td>Envio de e-mails</td>
              <td>E-mail, nome</td>
              <td>Global</td>
            </tr>
            <tr>
              <td>HostGator Brasil</td>
              <td>DNS e registro de domínio</td>
              <td>Navegação (DNS)</td>
              <td>Brasil</td>
            </tr>
          </tbody>
        </table>
      </div>
      <p>
        Não inserir fornecedores fictícios. Esta tabela reflete os provedores confirmados na
        infraestrutura atual.
      </p>
    </section>

    <section>
      <h2>9. Transferências internacionais</h2>
      <p>Alguns fornecedores de tecnologia poderão armazenar ou processar dados fora do Brasil.</p>
      <p>
        Quando houver transferência internacional de dados pessoais, deverão ser utilizados os
        mecanismos permitidos pela LGPD e pela regulamentação da Autoridade Nacional de Proteção de
        Dados.
      </p>
      <p>A relação de fornecedores e regiões de processamento deve ser mantida atualizada.</p>
    </section>

    <section>
      <h2>10. Cookies e tecnologias semelhantes</h2>
      <p>A landing page poderá utilizar cookies e tecnologias semelhantes para:</p>
      <ul>
        <li>funcionamento técnico;</li>
        <li>segurança;</li>
        <li>manutenção de sessão;</li>
        <li>armazenamento de preferências;</li>
        <li>medição de desempenho;</li>
        <li>análise de uso;</li>
        <li>publicidade, quando aplicável e autorizada.</li>
      </ul>
      <p>
        Cookies analíticos, publicitários ou de rastreamento não devem ser carregados antes da
        manifestação válida do usuário, quando dependerem de consentimento.
      </p>
      <p>
        Mais informações estão disponíveis na{' '}
        <Link to="/politica-de-cookies">Política de Cookies</Link>.
      </p>
    </section>

    <section>
      <h2>11. Retenção e eliminação</h2>
      <p>Os dados serão mantidos pelo período necessário para:</p>
      <ul>
        <li>prestar o serviço;</li>
        <li>manter a conta;</li>
        <li>cumprir o contrato;</li>
        <li>atender à finalidade informada;</li>
        <li>cumprir obrigações legais;</li>
        <li>proteger direitos;</li>
        <li>prevenir fraudes;</li>
        <li>manter registros de segurança.</li>
      </ul>
      <p>Quando o tratamento deixar de ser necessário, os dados poderão ser:</p>
      <ul>
        <li>eliminados;</li>
        <li>anonimizados;</li>
        <li>bloqueados;</li>
        <li>
          mantidos exclusivamente para cumprimento de obrigação legal ou exercício de direitos.
        </li>
      </ul>
      <p>
        O encerramento da conta não implica necessariamente a eliminação imediata de todos os
        registros, pois alguns dados poderão precisar ser preservados pelo prazo legal aplicável.
      </p>
    </section>

    <section>
      <h2>12. Segurança</h2>
      <p>
        A WR TECH INOVA SIMPLES (I.S.) adota medidas técnicas e administrativas compatíveis com a
        natureza dos dados, os riscos envolvidos e o estágio de desenvolvimento do serviço.
      </p>
      <p>As medidas poderão incluir:</p>
      <ul>
        <li>controle de acesso;</li>
        <li>autenticação;</li>
        <li>segregação de ambientes;</li>
        <li>registros de segurança;</li>
        <li>atualização de dependências;</li>
        <li>proteção de credenciais;</li>
        <li>cópias de segurança;</li>
        <li>restrição de permissões;</li>
        <li>resposta a incidentes;</li>
        <li>revisão de vulnerabilidades.</li>
      </ul>
      <p>
        Nenhum ambiente digital é completamente imune a falhas ou ataques. Esta página não promete
        segurança absoluta.
      </p>
    </section>

    <section>
      <h2>13. Direitos dos titulares</h2>
      <p>O titular poderá solicitar, conforme a legislação aplicável:</p>
      <ul>
        <li>confirmação da existência de tratamento;</li>
        <li>acesso aos dados;</li>
        <li>correção;</li>
        <li>anonimização;</li>
        <li>bloqueio;</li>
        <li>eliminação;</li>
        <li>portabilidade, quando aplicável;</li>
        <li>informação sobre compartilhamentos;</li>
        <li>informação sobre a possibilidade de não consentir;</li>
        <li>revogação do consentimento;</li>
        <li>oposição ao tratamento;</li>
        <li>revisão de decisão automatizada, quando aplicável.</li>
      </ul>
      <p>
        As solicitações poderão ser enviadas para:{' '}
        <a href="mailto:suporte@profeplan.com.br">suporte@profeplan.com.br</a>
      </p>
      <p>
        A empresa poderá solicitar informações necessárias para confirmar a identidade do requerente
        e impedir acesso indevido aos dados de terceiros.
      </p>
    </section>

    <section>
      <h2>14. Crianças e adolescentes</h2>
      <p>
        O ProfePlan é direcionado a profissionais da educação e não deve incentivar a criação direta
        de contas por crianças.
      </p>
      <p>
        Quando dados de crianças ou adolescentes forem inseridos por professores ou instituições,
        deverão ser observados:
      </p>
      <ul>
        <li>o melhor interesse do estudante;</li>
        <li>a necessidade pedagógica;</li>
        <li>a minimização;</li>
        <li>a segurança;</li>
        <li>a transparência;</li>
        <li>a autorização ou base legal aplicável;</li>
        <li>as políticas da instituição de ensino.</li>
      </ul>
      <p>O usuário não deve inserir dados de menores por mera conveniência ou curiosidade.</p>
    </section>

    <section>
      <h2>15. Comunicações de marketing</h2>
      <p>
        Comunicações necessárias ao funcionamento da conta poderão ser enviadas sem finalidade
        publicitária, incluindo:
      </p>
      <ul>
        <li>confirmação de cadastro;</li>
        <li>recuperação de senha;</li>
        <li>segurança;</li>
        <li>cobrança;</li>
        <li>alteração de serviço;</li>
        <li>suporte;</li>
        <li>avisos importantes.</li>
      </ul>
      <p>
        Newsletters, promoções e conteúdos comerciais deverão possuir base legal adequada e oferecer
        opção clara de descadastramento.
      </p>
    </section>

    <section>
      <h2>16. Incidentes de segurança</h2>
      <p>
        Caso seja identificado incidente de segurança envolvendo dados pessoais, a empresa realizará
        avaliação técnica e jurídica e adotará as providências aplicáveis.
      </p>
      <p>
        Comunicações aos titulares e à autoridade competente serão realizadas quando exigidas pela
        legislação.
      </p>
      <p>
        Suspeitas de incidente poderão ser comunicadas para:{' '}
        <a href="mailto:suporte@profeplan.com.br">suporte@profeplan.com.br</a>
      </p>
    </section>

    <section>
      <h2>17. Alterações desta política</h2>
      <p>Esta política poderá ser atualizada para refletir:</p>
      <ul>
        <li>alterações legais;</li>
        <li>novas funcionalidades;</li>
        <li>mudanças de fornecedores;</li>
        <li>mudanças de infraestrutura;</li>
        <li>novos tratamentos;</li>
        <li>aperfeiçoamentos de segurança.</li>
      </ul>
      <p>A data da versão mais recente permanecerá visível no início da página.</p>
      <p>Alterações relevantes poderão ser comunicadas pelos canais disponíveis.</p>
    </section>

    <section>
      <h2>18. Contato</h2>
      <p>
        <strong>WR TECH INOVA SIMPLES (I.S.)</strong>
        <br />
        CNPJ 65.458.067/0001-10
      </p>
      <p>
        Rua Varginha, nº 92
        <br />
        Bairro Planalto
        <br />
        Capelinha — Minas Gerais
        <br />
        CEP 39682-036
        <br />
        Brasil
      </p>
      <p>
        <strong>Canal de Privacidade e Proteção de Dados:</strong>
        <br />
        <a href="mailto:suporte@profeplan.com.br">suporte@profeplan.com.br</a>
      </p>
    </section>
  </LegalLayout>
);

export default PoliticaPrivacidade;
