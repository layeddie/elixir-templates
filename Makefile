.PHONY: install_phoenix create_project apply_template remove_nimble_phx_gen_template

# Y - in response to Are you sure you want to install "phx_new-${PHOENIX_VERSION}.ez"?
install_phoenix:
	printf "Y\n" | mix archive.install hex phx_new ${PHOENIX_VERSION}

create_project:
	mix phx.new ${PROJECT_DIRECTORY} ${OPTIONS}

# Y - in response to Will you host this project on Github?
# Y - in response to Do you want to generate the .github/ISSUE_TEMPLATE and .github/PULL_REQUEST_TEMPLATE?
# Y - in response to Do you want to generate the Github Action workflow?
# Y - in response to Would you like to add the Oban addon?
common_addon_prompts = Y\nY\nY\nY\n

# Y - in response to Would you like to add the CoreJS addon?
web_addon_prompts = Y\n

api_addon_prompts = 

# Y - in response to Fetch and install dependencies?
suffix_addon_prompts = Y\n

apply_template:
	cd ${PROJECT_DIRECTORY} && \
	echo '{:nimble_phx_gen_template, path: "../", only: :dev, runtime: false},' > nimble_phx_gen_template.txt && \
	sed -i -e '/{:phoenix, "~> /r nimble_phx_gen_template.txt' mix.exs && \
	rm nimble_phx_gen_template.txt && \
	mix deps.get && \
	mix format && \
	if [ $(VARIANT) = web ]; then \
		printf "${common_addon_prompts}${web_addon_prompts}${suffix_addon_prompts}" | mix nimble.phx.gen.template --web; \
	elif [ $(VARIANT) = api ]; then \
		printf "${common_addon_prompts}${api_addon_prompts}${suffix_addon_prompts}" | mix nimble.phx.gen.template --api; \
	fi;

remove_nimble_phx_gen_template:
	cd ${PROJECT_DIRECTORY} && \
	sed -i -e 's/{:nimble_phx_gen_template, path: "..\/"},//' mix.exs
