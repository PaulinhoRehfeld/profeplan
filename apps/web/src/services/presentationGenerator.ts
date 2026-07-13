// services/presentationGenerator.ts
import pptxgen from 'pptxgenjs';
import { getRelevantImage } from './unsplashService';

// Definição da estrutura que esperamos receber do Gemini
export interface SlideStructure {
  type: 'TITLE_SLIDE' | 'CONTENT_IMAGE_RIGHT' | 'CONTENT_ONLY';
  title: string;
  contentPoints: string[];
  imageSearchQuery?: string; // A IA sugere o que buscar visualmente
}

export const generateHighFidelityPPT = async (slideData: SlideStructure[], topic: string) => {
  const pres = new pptxgen();

  // --- 1. Configuração de Metadados e Layouts Mestre ---
  pres.title = `Aula sobre ${topic} - PROFEPLAN`;
  pres.subject = topic;
  pres.author = 'PROFEPLAN AI';

  // Define um layout mestre para slides de conteúdo com imagem à direita
  pres.defineSlideMaster({
    title: 'MASTER_IMAGE_RIGHT',
    background: { color: 'F5F5F5' },
    objects: [
      // Barra de título
      { rect: { x: 0.5, y: 0.4, w: '90%', h: 0.8, fill: { color: '0056b3' } } },
      {
        placeholder: {
          options: {
            name: 'title',
            type: 'title',
            x: 0.7,
            y: 0.5,
            w: '85%',
            h: 0.6,
            align: 'left',
            color: 'FFFFFF',
            fontSize: 24,
            bold: true,
          },
        },
      },
      // Área de texto à esquerda
      {
        placeholder: {
          options: {
            name: 'content',
            type: 'body',
            x: 0.7,
            y: 1.5,
            w: '45%',
            h: 5.0,
            fontSize: 18,
            color: '333333',
            bullet: true,
          },
        },
      },
      // Área de imagem à direita (placeholder visual)
      {
        rect: {
          x: 5.5,
          y: 1.5,
          w: 4.5,
          h: 4.0,
          fill: { color: 'E0E0E0' },
          line: { color: 'CCCCCC', width: 1 },
        },
      },
    ],
  });

  // --- 2. Geração dos Slides ---

  // Itera sobre os dados estruturados recebidos da IA
  for (const slide of slideData) {
    let slideRef;

    switch (slide.type) {
      case 'TITLE_SLIDE':
        slideRef = pres.addSlide();
        // Fundo gradiente para a capa
        slideRef.background = { color: '0056b3' };
        slideRef.addText(slide.title, {
          x: 1,
          y: 2.5,
          w: '80%',
          h: 1.5,
          fontSize: 44,
          color: 'FFFFFF',
          bold: true,
          align: 'center',
        });
        slideRef.addText(topic.toUpperCase(), {
          x: 1,
          y: 4,
          w: '80%',
          h: 0.5,
          fontSize: 20,
          color: 'FFD700',
          align: 'center',
        });
        break;

      case 'CONTENT_IMAGE_RIGHT':
        // Usa o layout mestre definido acima
        slideRef = pres.addSlide({ masterName: 'MASTER_IMAGE_RIGHT' });
        slideRef.addText(slide.title, { placeholder: 'title' });
        slideRef.addText(
          slide.contentPoints.map((p) => ({ text: p, options: { breakLine: true } })),
          { placeholder: 'content' }
        );

        // Busca e insere a imagem se houver uma query de busca
        if (slide.imageSearchQuery || (slide as any).imageSuggestion) {
          const query = slide.imageSearchQuery || (slide as any).imageSuggestion;
          const image = await getRelevantImage(query);
          if (image) {
            // Adiciona a imagem sobre o retângulo placeholder
            slideRef.addImage({ path: image.url, x: 5.5, y: 1.5, w: 4.5, h: 4.0 });
            // Adiciona crédito da imagem (obrigatório Unsplash)
            slideRef.addText(`Foto por ${image.credit} no Unsplash`, {
              x: 5.5,
              y: 5.6,
              fontSize: 9,
              color: '666666',
            });
          }
        }
        break;

      case 'CONTENT_ONLY':
      default:
        slideRef = pres.addSlide();
        slideRef.addText(slide.title, {
          x: 0.5,
          y: 0.5,
          w: '90%',
          h: 0.8,
          fontSize: 30,
          color: '0056b3',
          bold: true,
        });
        slideRef.addText(slide.contentPoints, {
          x: 0.5,
          y: 1.5,
          w: '90%',
          h: 5.0,
          fontSize: 18,
          color: '333333',
          bullet: true,
        });
        break;
    }
  }

  // --- 3. Salvar o Arquivo ---
  pres.writeFile({ fileName: `Aula_${topic.replace(/[^a-zA-Z0-9]/g, '_')}.pptx` });
};
