TAG=docsify/latest

.PHONY: build shell serve --run --run-it --run-t

build:
	docker build -t $(TAG) .

--run-it: RUN_IT=-it
--run-it: --run

--run-t: RUN_IT=-t
--run-t: --run

--run:
	docker run --rm $(RUN_IT) \
		--pid=host \
		-p 3000:3000 \
		--mount='type=bind,source=$(PWD)/docs,target=/docs' \
		$(TAG) \
		$(CMD)

serve: CMD=docsify serve .
serve: --run-it

shell: CMD=sh
shell: --run-it
