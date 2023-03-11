FROM public.ecr.aws/lambda/nodejs:18

COPY index.js package.json GeoLite2-City.mmdb ${LAMBDA_TASK_ROOT}/

RUN npm install

CMD [ "index.handler" ]
