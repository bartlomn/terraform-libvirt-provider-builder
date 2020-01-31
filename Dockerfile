#
# builder image
#
FROM golang:1.13-alpine3.11 as builder
RUN mkdir -p /build/src

# make sure git and glide packages are present
RUN apk update \
	&& apk add --update git \
	&& apk add --update openssh

# standard golang env setup
ENV GOPATH=/build
ENV GOBIN=/usr/local/go/bin
# enable module support (package management)
ENV GO111MODULE=on
WORKDIR $GOPATH/src

# get main project from git
ARG TERRA_VERSION=0.12.20
RUN wget https://releases.hashicorp.com/terraform/0.12.20/terraform_${TERRA_VERSION}_linux_amd64.zip \
	&& unzip terraform_${TERRA_VERSION}_linux_amd64.zip \
	&& chmod +x terraform \
	&& mv terraform /usr/local/bin \
	&& terraform version	

#RUN git clone https://github.com/fabianlee/go-vendortest1.git \
#	&& ls /build/src/go-vendortest1
#WORKDIR $GOPATH/src/go-vendortest1/vendortest

# compile, place executable into /build
# by default, use git HEAD of external package "go-myutil"
ARG BRANCH=HEAD
#RUN go mod init \
#	&& go get github.com/fabianlee/go-myutil@$BRANCH \
#	&& go list -m all \
#	&& CGO_ENABLED=0 GOOS=linux go build -a -o out . \
#	&& cp out $GOPATH/.

# intermediate executable
CMD [ "/build/out" ]


#
# generate clean, final image for end users
#
#FROM alpine:3.11.3
# copy golang binary into container
#COPY --from=builder /build/out .
# executable
#CMD [ "./out" ]

