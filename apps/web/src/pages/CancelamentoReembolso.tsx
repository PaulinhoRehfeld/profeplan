import React from 'react';
import { Link } from 'react-router-dom';
import { LegalLayout } from '../components/LegalLayout';

const CancelamentoReembolso: React.FC = () => (
  <LegalLayout title="Política de Cancelamento e Reembolso">
    <section>
      <h2>1. Cancelamento da renovação</h2>
      <p>
        Para solicitar o cancelamento da renovação da assinatura, o usuário deverá entrar em contato
        pelo e-mail <a href="mailto:suporte@profeplan.com.br">suporte@profeplan.com.br</a> ou
        utilizar o <Link to="/cancelamento/formulario">formulário eletrônico de cancelamento</Link>.
        A equipe enviará a confirmação do recebimento da solicitação e realizará as providências
        aplicáveis.
      </p>
      <p>
        Quando um painel de gerenciamento autônomo estiver disponível, ele também poderá ser
        utilizado para administrar a assinatura. Esta página será atualizada para refletir essa
        funcionalidade.
      </p>
      <p>
        O cancelamento não deve ser escondido nem exigir procedimento mais difícil que o utilizado
        na contratação.
      </p>
    </section>

    <section>
      <h2>2. Efeito do cancelamento</h2>
      <p>
        Salvo regra diferente exibida no momento da contratação, o cancelamento interromperá
        cobranças futuras e o plano permanecerá ativo até o fim do período já pago.
      </p>
    </section>

    <section>
      <h2>3. Direito de arrependimento</h2>
      <p>
        O consumidor poderá solicitar o exercício do direito de arrependimento dentro do prazo legal
        aplicável às contratações realizadas fora do estabelecimento comercial. Utilize o{' '}
        <Link to="/cancelamento/formulario">formulário eletrônico</Link> ou o e-mail{' '}
        <a href="mailto:suporte@profeplan.com.br">suporte@profeplan.com.br</a>.
      </p>
    </section>

    <section>
      <h2>4. Cobrança duplicada ou indevida</h2>
      <p>
        Cobranças duplicadas, transações não reconhecidas ou erros de processamento deverão ser
        investigados. Utilize o <Link to="/cancelamento/formulario">formulário eletrônico</Link>{' '}
        para reportar.
      </p>
    </section>

    <section>
      <h2>5. Reembolso</h2>
      <p>Pedidos de reembolso serão avaliados conforme:</p>
      <ul>
        <li>legislação aplicável;</li>
        <li>data da contratação;</li>
        <li>direito de arrependimento;</li>
        <li>cobrança duplicada;</li>
        <li>erro do sistema;</li>
        <li>indisponibilidade relevante;</li>
        <li>condições apresentadas antes da compra.</li>
      </ul>
    </section>

    <section>
      <h2>6. Forma de solicitação</h2>
      <p>
        <strong>Formulário eletrônico:</strong>{' '}
        <Link
          to="/cancelamento/formulario"
          style={{ color: '#818cf8', textDecoration: 'underline' }}
        >
          Acessar formulário de cancelamento, reembolso e direito de arrependimento
        </Link>
      </p>
      <p>
        <strong>E-mail:</strong>{' '}
        <a href="mailto:suporte@profeplan.com.br">suporte@profeplan.com.br</a>
      </p>
      <p>Informar:</p>
      <ul>
        <li>nome;</li>
        <li>e-mail da conta;</li>
        <li>plano;</li>
        <li>data aproximada;</li>
        <li>motivo;</li>
        <li>identificador da cobrança, quando disponível.</li>
      </ul>
      <p>
        <strong>Nunca</strong> enviar número completo do cartão ou código de segurança por e-mail ou
        formulário.
      </p>
    </section>
  </LegalLayout>
);

export default CancelamentoReembolso;
