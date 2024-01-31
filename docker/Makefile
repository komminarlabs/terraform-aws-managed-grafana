build:
	docker build -t grafana:8.5.3-1 .

deploy: build
	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNTID}.dkr.ecr.${AWS_REGION}.amazonaws.com
	docker tag grafana:8.5.3-1 ${AWS_ACCOUNTID}.dkr.ecr.${AWS_REGION}.amazonaws.com/grafana:8.5.3-1
	docker push ${AWS_ACCOUNTID}.dkr.ecr.${AWS_REGION}.amazonaws.com/grafana:8.5.3-1
