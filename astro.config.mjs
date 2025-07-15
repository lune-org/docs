// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: "Lune",
			logo: {
				src: "./src/assets/logo.svg",
				replacesTitle: true,
			},
			social: [
				{
					icon: "github",
					label: "GitHub",
					href: "https://github.com/lune-org/lune",
				},
			],
			sidebar: [
				{
					label: "Getting Started",
					items: [
						{
							label: "Installation",
							slug: "getting-started/1-installation",
						},
						{
							label: "Command-Line Usage",
							slug: "getting-started/2-command-line-usage",
						},
						{
							label: "Editor Setup",
							slug: "getting-started/3-editor-setup",
						},
						{
							label: "Security",
							slug: "getting-started/4-security",
						},
					],
				},
				{
					label: "The Lune Book",
					items: [
						{
							label: "1 ∙ Hello, Lune!",
							slug: "the-book/1-hello-lune",
						},
						{
							label: "2 ∙ Built-In Libraries",
							slug: "the-book/2-built-in-libraries",
						},
						{
							label: "3 ∙ Standard I/O",
							slug: "the-book/3-standard-io",
						},
						{
							label: "4 ∙ Script Arguments",
							slug: "the-book/4-script-arguments",
						},
						{
							label: "5 ∙ Network Requests",
							slug: "the-book/5-network-requests",
						},
						{
							label: "6 ∙ Files & Directories",
							slug: "the-book/6-files-and-directories",
						},
						{
							label: "7 ∙ Environment Variables",
							slug: "the-book/7-environment-variables",
						},
						{
							label: "8 ∙ Modules",
							slug: "the-book/8-modules",
						},
						{
							label: "9 ∙ The Task Scheduler",
							slug: "the-book/9-task-scheduler",
						},
						{
							label: "10 ∙ Spawning Processes",
							slug: "the-book/10-spawning-processes",
						},
					],
				},
				{
					label: "Roblox",
					items: [
						{
							label: "Introduction",
							slug: "roblox/1-introduction",
						},
						{
							label: "Example Scripts",
							slug: "roblox/2-examples",
						},
						{
							label: "Remodel Migration",
							slug: "roblox/3-remodel-migration",
						},
						{
							label: "API Status",
							slug: "roblox/4-api-status",
						},
					],
				},
				{
					label: "API Reference",
					autogenerate: { directory: "api-reference" },
				},
			],
		}),
	],
});
