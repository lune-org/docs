import React from "react"

import { useRouter } from "next/router"

export default {
	docsRepositoryBase: "https://github.com/lune-org/docs/blob/main",
	useNextSeoProps() {
		const { asPath } = useRouter()
		if (asPath !== "/") {
			return {
				titleTemplate: "%s – Lune",
			}
		}
	},
	project: {
		link: "https://github.com/filiptibell/lune",
	},
	footer: {
		text: (
			<span>
				MPL-2.0 {new Date().getFullYear()} ©{" "}
				<a href="https://github.com/filiptibell/lune" target="_blank">
					Lune
				</a>
			</span>
		),
	},
	logo: (
		<>
			<img
				width="40"
				height="40"
				src="https://github.com/filiptibell/lune/raw/main/assets/logo/tilt.png"
			/>
		</>
	),
}
