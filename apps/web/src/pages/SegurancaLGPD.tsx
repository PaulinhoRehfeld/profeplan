import React from 'react';
import { Link } from 'react-router-dom';
import { LegalLayout } from '../components/LegalLayout';

const SegurancaLGPD: React.FC = () => (
  <LegalLayout title="Segurança, Privacidade e LGPD">
    <section>
      <p>A <strong>WR TECH INOVA SIMPLES (I.S.)</strong> busca incorporar privacidade e segurança ao desenvolvimento do ProfePlan.</p>

      <h2>Nossos compromissos</h2>
      <ul>
        <li>minimização de dados;</li>
        <li>controle de acesso;</li>
        <li>proteção de credenciais;</li>
        <li>revisão de permissões;</li>
        <li>atualização de dependências;</li>
        <li>monitoramento técnico;</li>
        <li>prevenção de acessos indevidos;</li>
        <li>resposta a incidentes;</li>
        <li>transparência;</li>
        <li>respeito aos direitos dos titulares.</li>
      </ul>

      <p>A implementação dessas medidas é revisada continuamente conforme a evolução do produto.</p>

      <h2>O que esta página não declara</h2>
      <p>Não declaramos medidas específicas que não estejam comprovadas tecnicamente na infraestrutura atual.</p>
      <p>Não afirmamos possuir certificações como ISO 27001, SOC 2 ou equivalentes sem a devida comprovação.</p>
      <p>Não prometemos segurança absoluta ou risco zero.</p>

      <h2>Canal de Privacidade e Proteção de Dados</h2>
      <p>Para assuntos relacionados à privacidade, proteção de dados ou suspeitas de incidentes de segurança:</p>
      <p><a href="mailto:suporte@profeplan.com.br">suporte@profeplan.com.br</a></p>

      <h2>Documentos relacionados</h2>
      <ul>
        <li><Link to="/politica-de-privacidade">Política de Privacidade</Link></li>
        <li><Link to="/termos-de-uso">Termos de Uso</Link></li>
        <li><Link to="/politica-de-cookies">Política de Cookies</Link></li>
        <li><Link to="/direitos-do-titular">Direitos do Titular</Link></li>
        <li><Link to="/dados-educacionais">Dados Educacionais</Link></li>
      </ul>

      <h2>Contato da empresa</h2>
      <p><strong>WR TECH INOVA SIMPLES (I.S.)</strong><br />
      CNPJ 65.458.067/0001-10</p>
      <p>Rua Varginha, nº 92, Bairro Planalto<br />
      Capelinha — MG — CEP 39682-036<br />
      Brasil
    </p>
    </section>
  </LegalLayout>
);

export default SegurancaLGPD;

