import nextra from "nextra";

const withNextra = nextra({});

/**
 * @type {import('next').NextConfig}
 */
const nextConfig = {
	output: "export",
	basePath: "/docs",
	images: {
		unoptimized: true,
	},
	turbopack: {
		resolveAlias: {
			"next-mdx-import-source-file": "./src/mdx-components.js",
		},
	},
};

export default withNextra(nextConfig);
