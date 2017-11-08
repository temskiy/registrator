FROM alpine:3.5
ENTRYPOINT ["/bin/registrator"]

ENV GOPATH /go
RUN apk --no-cache add -t build-deps build-base go git \
	&& apk --no-cache add ca-certificates
COPY . /go/src/github.com/temskiy/registrator
RUN git config --global http.https://gopkg.in.followRedirects true \
        && go get -u github.com/ugorji/go/codec/codecgen \
        && go get -u github.com/coreos/go-etcd/etcd || cd /go/src/github.com/coreos/go-etcd/etcd \
        && /go/bin/codecgen -d 1978 -o response.generated.go response.go \
        && cd /go/src/github.com/temskiy/registrator \
        && go get -a -v \
	&& go build -ldflags "-X main.Version=$(cat VERSION)" -o /bin/registrator \
	&& rm -rf /go \
	&& apk del --purge build-deps
