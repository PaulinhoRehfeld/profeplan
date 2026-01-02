
// services/unsplashService.ts

const UNSPLASH_ACCESS_KEY = import.meta.env.VITE_UNSPLASH_ACCESS_KEY;

export interface UnsplashImage {
    url: string;
    credit: string;
    creditLink: string;
}

export const getRelevantImage = async (query: string): Promise<UnsplashImage | null> => {
    if (!UNSPLASH_ACCESS_KEY) {
        console.warn("Unsplash Access Key not set.");
        return null;
    }

    try {
        // Busca uma foto aleatória relevante para o termo
        const response = await fetch(
            `https://api.unsplash.com/photos/random?query=${encodeURIComponent(query)}&orientation=landscape&content_filter=high`,
            {
                headers: {
                    Authorization: `Client-ID ${UNSPLASH_ACCESS_KEY}`,
                },
            }
        );

        if (!response.ok) {
            throw new Error(`Unsplash error: ${response.statusText}`);
        }

        const data = await response.json();

        // É obrigatório pelos termos do Unsplash dar crédito
        return {
            url: data.urls.regular, // Usa a versão de tamanho regular
            credit: data.user.name,
            creditLink: data.user.links.html,
        };

    } catch (error) {
        console.error("Error fetching image from Unsplash:", error);
        // Retorna null para que o slide seja gerado sem imagem em caso de erro, sem quebrar o app
        return null;
    }
};
