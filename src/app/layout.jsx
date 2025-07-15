import { Footer, Layout, Navbar } from "nextra-theme-docs";
import { Head } from "nextra/components";
import { getPageMap } from "nextra/page-map";
import "nextra-theme-docs/style.css";

export const metadata = {};

const navbar = (
	<Navbar
		projectLink="https://github.com/lune-org/lune"
		logo={
			<img
				width="40"
				height="40"
				src="https://github.com/lune-org/lune/raw/main/assets/logo/tilt.png"
			/>
		}
	/>
);
const footer = (
	<Footer>
		MPL-2.0 {new Date().getFullYear()} ©{" "}
		<a href="https://github.com/lune-org/lune" target="_blank">
			Lune
		</a>
	</Footer>
);

export default async function RootLayout({ children }) {
	return (
		<html lang="en" dir="ltr" suppressHydrationWarning>
			<Head>
				<link
					rel="icon"
					href="https://github.com/lune-org/lune/raw/main/assets/logo/tilt.png"
					type="image/png"
				/>
			</Head>
			<body>
				<Layout
					navbar={navbar}
					pageMap={await getPageMap()}
					docsRepositoryBase="https://github.com/lune-org/docs/tree/main"
					footer={footer}
				>
					{children}
				</Layout>
			</body>
		</html>
	);
}
