🏛️ PROFEPLAN - Manifesto de Arquitetura e Negócios
1. A Visão B2G e o Ecossistema:
O PROFEPLAN não é um gerador de texto simples. É um Ecossistema Educacional B2G focado primeiramente em atender professores da rede pública do Estado de Minas Gerais (SEE/MG) e, futuramente, o Brasil. O código deve ser modular e escalável para suportar múltiplas integrações escolares.

2. A Estratégia de Integração (O Firewall):
O acesso a redes públicas tem restrições rigorosas (firewalls). Portanto, a arquitetura de Identidade deve ser sempre:

Autenticação Principal: E-mail pessoal do professor (Supabase Auth).

Integração Secundária (OAuth 2.0): Vinculação com contas @educacao.mg.gov.br (Google Classroom/Drive) feita após o login, garantindo que o app continue funcionando mesmo se a integração institucional falhar.

3. Arquitetura de IA (Multi-Agentes OpenAI):
Estamos migrando para a infraestrutura da OpenAI (Azure). O sistema não deve usar um único prompt monolítico. O código deve ser estruturado prevendo um Sistema Multi-Agentes:

Agente Planejador: Focado no escopo macro e regras da BNCC.

Agente Didático: Focado no roteiro de aula passo a passo.

Agente Avaliador: Focado em gerar avaliações (utilizando "Structured Outputs" da OpenAI para devolver JSON rígido).

4. Stack Tecnológico Estrito:

Frontend: React + Vite + TailwindCSS.

Backend/Auth: Supabase.

PWA: O sistema é um Progressive Web App. Qualquer atualização deve usar o VitePWA com autoUpdate e cleanupOutdatedCaches para evitar loops de atualização.

Regra de Ouro para a IA: Antes de propor qualquer refatoração ou alteração de código, avalie se a sua sugestão respeita esta visão de ecossistema e não quebra a estratégia de contorno do firewall do Estado.