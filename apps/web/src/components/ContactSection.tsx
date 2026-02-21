import React, { useState, FormEvent } from 'react';
import { Send, MessageCircle, Mail, User, FileText, CheckCircle, AlertCircle } from 'lucide-react';

interface ContactFormData {
    name: string;
    email: string;
    subject: string;
    message: string;
}

const ContactSection: React.FC = () => {
    const [formData, setFormData] = useState<ContactFormData>({
        name: '',
        email: '',
        subject: '',
        message: ''
    });
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [submitStatus, setSubmitStatus] = useState<'idle' | 'success' | 'error'>('idle');

    const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
    };

    const handleSubmit = async (e: FormEvent) => {
        e.preventDefault();
        setIsSubmitting(true);
        setSubmitStatus('idle');

        try {
            // Web3Forms API endpoint
            const response = await fetch('https://api.web3forms.com/submit', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    access_key: '86217bad-3cc9-4824-b12e-f821d99f44cf',
                    name: formData.name,
                    email: formData.email,
                    subject: formData.subject,
                    message: formData.message,
                    from_name: 'ProfePlan Landing Page',
                    to_email: 'suporte@profeplan.com.br'
                }),
            });

            const result = await response.json();

            if (response.ok && result.success) {
                setSubmitStatus('success');
                setFormData({ name: '', email: '', subject: '', message: '' });

                // Reset status after 5 seconds
                setTimeout(() => setSubmitStatus('idle'), 5000);
            } else {
                throw new Error('Falha no envio');
            }
        } catch (error) {
            console.error('Erro ao enviar formulário:', error);
            setSubmitStatus('error');

            // Reset status after 5 seconds
            setTimeout(() => setSubmitStatus('idle'), 5000);
        } finally {
            setIsSubmitting(false);
        }
    };

    const whatsappMessage = encodeURIComponent('Olá! Gostaria de mais informações sobre o ProfePlan.');
    const whatsappLink = `https://wa.me/5533999989922?text=${whatsappMessage}`;

    return (
        <section id="contato" className="py-20 md:py-28 px-4 bg-gradient-to-b from-white to-slate-50">
            <div className="max-w-6xl mx-auto">
                {/* Header */}
                <div className="text-center mb-12 space-y-3">
                    <h2 className="text-3xl md:text-5xl font-black text-slate-900">
                        Entre em Contato
                    </h2>
                    <p className="text-lg md:text-xl text-slate-600 max-w-2xl mx-auto">
                        Tem dúvidas? Estamos aqui para ajudar! Escolha a melhor forma de falar conosco.
                    </p>
                </div>

                <div className="grid md:grid-cols-2 gap-8">
                    {/* Email Form Card */}
                    <div className="bg-white border-2 border-slate-200 rounded-3xl p-8 shadow-lg hover:shadow-xl transition-all">
                        <div className="flex items-center gap-3 mb-6">
                            <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                                <Mail size={24} className="text-blue-600" />
                            </div>
                            <h3 className="text-2xl font-bold text-slate-900">Envie um Email</h3>
                        </div>

                        <form onSubmit={handleSubmit} className="space-y-5">
                            {/* Nome */}
                            <div className="space-y-2">
                                <label htmlFor="name" className="block text-sm font-semibold text-slate-700">
                                    Nome
                                </label>
                                <div className="relative">
                                    <User size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
                                    <input
                                        type="text"
                                        id="name"
                                        name="name"
                                        value={formData.name}
                                        onChange={handleInputChange}
                                        required
                                        className="w-full pl-12 pr-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all outline-none"
                                        placeholder="Seu nome completo"
                                        disabled={isSubmitting}
                                    />
                                </div>
                            </div>

                            {/* Email */}
                            <div className="space-y-2">
                                <label htmlFor="email" className="block text-sm font-semibold text-slate-700">
                                    Email
                                </label>
                                <div className="relative">
                                    <Mail size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
                                    <input
                                        type="email"
                                        id="email"
                                        name="email"
                                        value={formData.email}
                                        onChange={handleInputChange}
                                        required
                                        className="w-full pl-12 pr-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all outline-none"
                                        placeholder="seu@email.com"
                                        disabled={isSubmitting}
                                    />
                                </div>
                            </div>

                            {/* Assunto */}
                            <div className="space-y-2">
                                <label htmlFor="subject" className="block text-sm font-semibold text-slate-700">
                                    Assunto
                                </label>
                                <div className="relative">
                                    <FileText size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
                                    <input
                                        type="text"
                                        id="subject"
                                        name="subject"
                                        value={formData.subject}
                                        onChange={handleInputChange}
                                        required
                                        className="w-full pl-12 pr-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all outline-none"
                                        placeholder="Sobre o que deseja falar?"
                                        disabled={isSubmitting}
                                    />
                                </div>
                            </div>

                            {/* Mensagem */}
                            <div className="space-y-2">
                                <label htmlFor="message" className="block text-sm font-semibold text-slate-700">
                                    Mensagem
                                </label>
                                <textarea
                                    id="message"
                                    name="message"
                                    value={formData.message}
                                    onChange={handleInputChange}
                                    required
                                    rows={4}
                                    className="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all outline-none resize-none"
                                    placeholder="Digite sua mensagem aqui..."
                                    disabled={isSubmitting}
                                />
                            </div>

                            {/* Submit Button */}
                            <button
                                type="submit"
                                disabled={isSubmitting}
                                className="w-full py-4 bg-blue-600 hover:bg-blue-700 disabled:bg-slate-400 text-white font-bold rounded-xl shadow-md hover:shadow-lg transition-all flex items-center justify-center gap-2"
                            >
                                {isSubmitting ? (
                                    <>
                                        <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                                        Enviando...
                                    </>
                                ) : (
                                    <>
                                        <Send size={20} />
                                        Enviar Mensagem
                                    </>
                                )}
                            </button>

                            {/* Status Messages */}
                            {submitStatus === 'success' && (
                                <div className="flex items-center gap-2 p-4 bg-green-50 border border-green-200 rounded-xl text-green-700 animate-fadeIn">
                                    <CheckCircle size={20} />
                                    <span className="font-medium">Mensagem enviada com sucesso!</span>
                                </div>
                            )}

                            {submitStatus === 'error' && (
                                <div className="flex items-center gap-2 p-4 bg-red-50 border border-red-200 rounded-xl text-red-700 animate-fadeIn">
                                    <AlertCircle size={20} />
                                    <span className="font-medium">Erro ao enviar. Tente novamente ou use o WhatsApp.</span>
                                </div>
                            )}
                        </form>
                    </div>

                    {/* WhatsApp Card */}
                    <div className="bg-gradient-to-br from-green-50 to-emerald-50 border-2 border-green-200 rounded-3xl p-8 shadow-lg hover:shadow-xl transition-all flex flex-col">
                        <div className="flex items-center gap-3 mb-6">
                            <div className="w-12 h-12 bg-green-500 rounded-xl flex items-center justify-center">
                                <MessageCircle size={24} className="text-white" />
                            </div>
                            <h3 className="text-2xl font-bold text-slate-900">WhatsApp</h3>
                        </div>

                        <div className="space-y-6 flex-1">
                            <p className="text-slate-700 leading-relaxed">
                                Precisa de uma resposta mais rápida? Fale conosco diretamente pelo WhatsApp!
                            </p>

                            <div className="bg-white border border-green-200 rounded-2xl p-6 space-y-4">
                                <div>
                                    <p className="text-sm font-semibold text-slate-600 mb-1">Número:</p>
                                    <p className="text-2xl font-bold text-slate-900">(33) 99998-9922</p>
                                </div>

                                <div>
                                    <p className="text-sm font-semibold text-slate-600 mb-1">Horário de Atendimento:</p>
                                    <p className="text-slate-700">Segunda a Sexta, 8h às 18h</p>
                                </div>
                            </div>

                            <a
                                href={whatsappLink}
                                target="_blank"
                                rel="noopener noreferrer"
                                className="w-full py-4 bg-green-500 hover:bg-green-600 text-white font-bold rounded-xl shadow-md hover:shadow-lg transition-all flex items-center justify-center gap-2 group"
                            >
                                <MessageCircle size={20} className="group-hover:scale-110 transition-transform" />
                                Abrir WhatsApp
                            </a>

                            <p className="text-sm text-slate-500 text-center">
                                A mensagem será pré-preenchida, mas você pode editá-la antes de enviar.
                            </p>
                        </div>
                    </div>
                </div>

                {/* Opcional: Informações de Contato Direto */}
                <div className="mt-12 text-center">
                    <p className="text-slate-600">
                        Ou envie um email diretamente para:{' '}
                        <a
                            href="mailto:suporte@profeplan.com.br"
                            className="text-blue-600 hover:text-blue-700 font-semibold hover:underline transition-colors"
                        >
                            suporte@profeplan.com.br
                        </a>
                    </p>
                </div>
            </div>
        </section>
    );
};

export default ContactSection;
