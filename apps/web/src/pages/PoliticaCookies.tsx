import React from 'react';
import { Link } from 'react-router-dom';
import { LegalLayout } from '../components/LegalLayout';

const PoliticaCookies: React.FC = () => (
  <LegalLayout title="Política de Cookies do ProfePlan">
    <section>
      <h2>1. O que são cookies</h2>
      <p>
        Cookies são pequenos arquivos ou identificadores armazenados no dispositivo do usuário para
        permitir o funcionamento de páginas e serviços digitais.
      </p>
    </section>

    <section>
      <h2>2. Categorias</h2>

      <h3>Cookies estritamente necessários</h3>
      <p>
        São utilizados para funcionamento, segurança, autenticação, manutenção de sessão e registro
        de preferências.
      </p>
      <p>
        Esses cookies não devem ser desativados quando forem indispensáveis ao funcionamento
        solicitado.
      </p>

      <h3>Cookies funcionais</h3>
      <p>Permitem lembrar escolhas do usuário, como idioma, aparência e preferências.</p>

      <h3>Cookies analíticos</h3>
      <p>Permitem compreender como o site é utilizado.</p>
      <p>
        Somente devem ser ativados quando houver fundamento legal adequado e, quando necessário,
        consentimento.
      </p>

      <h3>Cookies de marketing</h3>
      <p>Podem ser utilizados para medir campanhas ou personalizar publicidade.</p>
      <p>Devem permanecer desativados até a autorização válida do usuário.</p>
    </section>

    <section>
      <h2>3. Cookies identificados nesta versão</h2>
      <div style={{ overflowX: 'auto' }}>
        <table>
          <thead>
            <tr>
              <th>Nome / Fonte</th>
              <th>Fornecedor</th>
              <th>Finalidade</th>
              <th>Categoria</th>
              <th>Duração</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Supabase Auth Token</td>
              <td>Supabase</td>
              <td>Autenticação e sessão</td>
              <td>Necessário</td>
              <td>Sessão</td>
            </tr>
            <tr>
              <td>Vercel Edge Cache</td>
              <td>Vercel</td>
              <td>CDN e desempenho</td>
              <td>Necessário</td>
              <td>Variável</td>
            </tr>
            <tr>
              <td>localStorage (prefs)</td>
              <td>Próprio</td>
              <td>Preferências de uso</td>
              <td>Funcional</td>
              <td>Persistente</td>
            </tr>
            <tr>
              <td>Stripe (checkout)</td>
              <td>Stripe</td>
              <td>Processamento de pagamento</td>
              <td>Necessário</td>
              <td>Sessão</td>
            </tr>
          </tbody>
        </table>
      </div>
      <p>
        <em>
          Nota: Nenhum cookie de analytics, marketing ou rastreamento publicitário foi identificado
          como ativo no código-fonte desta versão. Esta tabela será atualizada sempre que novos
          scripts forem incorporados.
        </em>
      </p>
      <p>
        Atualmente, a landing page pública do ProfePlan não utiliza cookies analíticos,
        publicitários ou de marketing que dependam do consentimento do visitante. Poderão ser
        utilizados recursos estritamente necessários ao funcionamento, à segurança e à manutenção
        das preferências básicas do site.
      </p>
    </section>

    <section>
      <h2>4. Situação atual</h2>
      <p>
        Atualmente, a landing page pública do ProfePlan não utiliza cookies analíticos,
        publicitários ou de marketing que dependam do consentimento do visitante. Poderão ser
        utilizados recursos estritamente necessários ao funcionamento, à segurança e à manutenção
        das preferências básicas do site.
      </p>
      <p>
        Enquanto forem utilizados exclusivamente cookies ou recursos estritamente necessários, não
        será apresentado um banner solicitando consentimento.
      </p>
    </section>

    <section>
      <h2>5. Implementação futura</h2>
      <p>
        Um banner interativo de consentimento será implementado antes da ativação de qualquer
        recurso como:
      </p>
      <ul>
        <li>Google Analytics;</li>
        <li>Google Tag Manager com tags opcionais;</li>
        <li>Meta Pixel;</li>
        <li>Microsoft Clarity;</li>
        <li>Hotjar;</li>
        <li>TikTok Pixel;</li>
        <li>LinkedIn Insight Tag;</li>
        <li>ferramentas de remarketing;</li>
        <li>publicidade personalizada;</li>
        <li>rastreamento comportamental;</li>
        <li>vídeos incorporados que instalem cookies não necessários;</li>
        <li>widgets externos que realizem rastreamento.</li>
      </ul>
      <p>
        Quando isso acontecer, o banner apresentará, no mesmo nível visual, as opções "Rejeitar não
        necessários", "Personalizar" e "Aceitar todos". Cookies não necessários permanecerão
        desativados até que o usuário manifeste uma escolha válida.
      </p>
      <p>
        A ausência atual do banner não elimina a necessidade de realizar nova auditoria sempre que
        forem adicionados scripts, integrações, ferramentas de analytics ou recursos externos.
      </p>
    </section>

    <section>
      <h2>6. Contato</h2>
      <p>
        Dúvidas sobre cookies poderão ser enviadas para:{' '}
        <a href="mailto:suporte@profeplan.com.br">suporte@profeplan.com.br</a>
      </p>
    </section>
  </LegalLayout>
);

export default PoliticaCookies;
