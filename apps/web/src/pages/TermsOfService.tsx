import React from 'react';
import { ArrowLeft } from 'lucide-react';
import { Link } from 'react-router-dom';

const TermsOfService: React.FC = () => {
    return (
        <div className="min-h-screen bg-slate-50 font-sans text-slate-800">
            <div className="max-w-4xl mx-auto px-6 py-12">
                <div className="mb-8">
                    <Link to="/" className="inline-flex items-center gap-2 text-slate-500 hover:text-blue-600 transition-colors mb-4">
                        <ArrowLeft size={20} />
                        Voltar para a página inicial
                    </Link>
                    <h1 className="text-3xl md:text-4xl font-black text-slate-900 mb-2">Termos de Serviço</h1>
                    <p className="text-slate-500">Última atualização: 26 de janeiro de 2026</p>
                </div>

                <div className="bg-white rounded-2xl shadow-sm p-8 md:p-12 space-y-8">
                    <section>
                        <h2 className="text-xl font-bold text-slate-900 mb-4">1. Termos</h2>
                        <p className="leading-relaxed">
                            Ao acessar ao site <span className="font-bold">ProfePlan</span>, concorda em cumprir estes termos de serviço, todas as leis e regulamentos aplicáveis e concorda que é responsável pelo cumprimento de todas as leis locais aplicáveis. Se você não concordar com algum desses termos, está proibido de usar ou acessar este site. Os materiais contidos neste site são protegidos pelas leis de direitos autorais e marcas comerciais aplicáveis.
                        </p>
                    </section>

                    <section>
                        <h2 className="text-xl font-bold text-slate-900 mb-4">2. Uso de Licença</h2>
                        <p className="leading-relaxed mb-4">
                            É concedida permissão para baixar temporariamente uma cópia dos materiais (informações ou software) no site ProfePlan , apenas para visualização transitória pessoal e não comercial. Esta é a concessão de uma licença, não uma transferência de título e, sob esta licença, você não pode:
                        </p>
                        <ul className="list-disc pl-6 space-y-2 mt-2">
                            <li>Modificar ou copiar os materiais;</li>
                            <li>Usar os materiais para qualquer finalidade comercial ou para exibição pública (comercial ou não comercial);</li>
                            <li>Tentar descompilar ou fazer engenharia reversa de qualquer software contido no site ProfePlan;</li>
                            <li>Remover quaisquer direitos autorais ou outras notações de propriedade dos materiais; ou</li>
                            <li>Transferir os materiais para outra pessoa ou 'espelhe' os materiais em qualquer outro servidor.</li>
                        </ul>
                        <p className="leading-relaxed mt-4">
                            Esta licença será automaticamente rescindida se você violar alguma dessas restrições e poderá ser rescindida por ProfePlan a qualquer momento. Ao encerrar a visualização desses materiais ou após o término desta licença, você deve apagar todos os materiais baixados em sua posse, seja em formato eletrônico ou impresso.
                        </p>
                    </section>

                    <section>
                        <h2 className="text-xl font-bold text-slate-900 mb-4">3. Isenção de responsabilidade</h2>
                        <p className="leading-relaxed mb-4">
                            Os materiais no site da ProfePlan são fornecidos 'como estão'. ProfePlan não oferece garantias, expressas ou implícitas, e, por este meio, isenta e nega todas as outras garantias, incluindo, sem limitação, garantias implícitas ou condições de comercialização, adequação a um fim específico ou não violação de propriedade intelectual ou outra violação de direitos.
                        </p>
                        <p className="leading-relaxed">
                            Além disso, o ProfePlan não garante ou faz qualquer representação relativa à precisão, aos resultados prováveis ou à confiabilidade do uso dos materiais em seu site ou de outra forma relacionado a esses materiais ou em sites vinculados a este site.
                        </p>
                    </section>

                    <section>
                        <h2 className="text-xl font-bold text-slate-900 mb-4">4. Limitações</h2>
                        <p className="leading-relaxed">
                            Em nenhum caso o ProfePlan ou seus fornecedores serão responsáveis por quaisquer danos (incluindo, sem limitação, danos por perda de dados ou lucro ou devido a interrupção dos negócios) decorrentes do uso ou da incapacidade de usar os materiais em ProfePlan, mesmo que ProfePlan ou um representante autorizado da ProfePlan tenha sido notificado oralmente ou por escrito da possibilidade de tais danos.
                        </p>
                    </section>

                    <section>
                        <h2 className="text-xl font-bold text-slate-900 mb-4">5. Precisão dos materiais</h2>
                        <p className="leading-relaxed">
                            Os materiais exibidos no site da ProfePlan podem incluir erros técnicos, tipográficos ou fotográficos. ProfePlan não garante que qualquer material em seu site seja preciso, completo ou atual. ProfePlan pode fazer alterações nos materiais contidos em seu site a qualquer momento, sem aviso prévio. No entanto, ProfePlan não se compromete a atualizar os materiais.
                        </p>
                    </section>

                    <section>
                        <h2 className="text-xl font-bold text-slate-900 mb-4">6. Links</h2>
                        <p className="leading-relaxed">
                            O ProfePlan não analisou todos os sites vinculados ao seu site e não é responsável pelo conteúdo de nenhum site vinculado. A inclusão de qualquer link não implica endosso por ProfePlan do site. O uso de qualquer site vinculado é por conta e risco do usuário.
                        </p>
                    </section>

                    <section>
                        <h2 className="text-xl font-bold text-slate-900 mb-4">7. Modificações</h2>
                        <p className="leading-relaxed">
                            O ProfePlan pode revisar estes termos de serviço do site a qualquer momento, sem aviso prévio. Ao usar este site, você concorda em ficar vinculado à versão atual desses termos de serviço.
                        </p>
                    </section>

                    <section>
                        <h2 className="text-xl font-bold text-slate-900 mb-4">8. Lei aplicável</h2>
                        <p className="leading-relaxed">
                            Estes termos e condições são regidos e interpretados de acordo com as leis do ProfePlan e você se submete irrevogavelmente à jurisdição exclusiva dos tribunais naquele estado ou localidade.
                        </p>
                    </section>
                </div>
            </div>
        </div>
    );
};

export default TermsOfService;
