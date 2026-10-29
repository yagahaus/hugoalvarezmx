/* src/content.config.ts */
import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const paginas = defineCollection({
  // El nuevo loader hiper-rápido de Astro 6
  loader: glob({ pattern: "**/*.{md,mdx}", base: "./src/content/paginas" }),
  schema: z.object({
    title: z.string().optional().default("Sin título"),
    description: z.string().optional().default(""),
    pubDate: z.coerce.date().optional(),
    heroImage: z.string().optional(),
  }),
});

const blog = defineCollection({
  loader: glob({ pattern: "**/*.{md,mdx}", base: "./src/content/blog" }),
  schema: z.object({
    title: z.string().optional().default("Sin título"),
    description: z.string().optional().default(""),
    author: z.string().optional(),
    category: z.string().optional(),
    pubDate: z.coerce.date().optional(),
    heroImage: z.string().optional(),
  }),
});

export const collections = { paginas, blog };