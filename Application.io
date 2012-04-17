doFile("EvHttpServer.io")

IndexHandler := Object clone do (
    get := method(request,
       return "hello"
    )
)

app := Application clone
app append("/", IndexHandler)
app append("/index", IndexHandler)

URL with("http://www.yahoo.com/") fetch
EvHttpServer clone setHost("127.0.0.1") setPort(8080) setRequestHandlerProto(RequestHandler) run
Coroutine currentCoroutine pause
loop(yield)
