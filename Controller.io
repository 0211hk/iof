Application := Object clone do(
    applications := List clone
    static := "/static/"
    append := method(key, value,
        m := Map clone
        m atPut(key, value)
        applications append(m)
    )
)
Application clone = Application

Http404Error := Exception clone do(
    init := method(
        self statusCode := 404
        self responseMessage := "Not Found"
    )
)

Http500Error := Exception clone do(
    init := method(
        self statusCode := 500
        self responseMessage := "InternalServerError"
    )
)

RequestHandler := Object clone do(
    init := method(
        self app = Application clone
    )
    handleRequest := method(request, response,
        e := try(
            response data = self _handle(request)
            response statusCode := 200
            response responseMessage := "OK"
        )
        e catch(Exception,
            "error" print
            error := self _handleError(e)
            response statusCode := error statusCode
            response responseMessage := error responseMessage
            response data = error data
        )
        response asyncSend
        response headers = request headers
    )
    _handle := method(request,
        self app applications foreach(i, v,
            v foreach(key, value,
                if(request path == key,return value perform(request httpMethod asLowercase, request))
            )
        )
        Http404Error raise("Error")
    )
    _handleError := method(e,
        errorResponse := Object clone do(
            statusCode := 500
            responseMessage := "InternalServerError"
            data := "InternalServerError"
        )
        if(e hasSlot("statusCode"),errorResponse statusCode := e statusCode)
        if(e hasSlot("responseMessage"),errorResponse responseMessage := e responseMessage)

        if(e hasSlot("file"),
            file := File with(e file) openForReading;errorResponse data := file contents,
            if(e hasSlot("responseMessage"),errorResponse data := e responseMessage,errorResponse data := "InternalServerError")
        )
        return errorResponse
    )
)