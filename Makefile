.PHONY: install_phoenix create_project apply_template

install_phoenix:
	printf "Y\n" | mix archive.install hex phx_new ${PHOENIX_VERSION}

create_project:
	printf "Y\nY\n" | mix phx.new ${VARIANT}_project

apply_template:
	cd ${VARIANT}_project && \
	echo '{:nimble_phx_gen_template, path: "../"},' > nimble_phx_gen_template.txt && \
	sed -i -e '/{:phoenix, "~> ${PHOENIX_VERSION}"}/r nimble_phx_gen_template.txt' mix.exs && \
	rm nimble_phx_gen_template.txt && \
	mix deps.get && \
	mix format && \
	printf "Y\nY\nY\nY\n" | mix nimble.phx.gen.template --${VARIANT}
