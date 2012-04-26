Model := Object clone do(

    init := method(
        self user := nil
        self password := nil
        self host := nil
        self database := nil
        self Builder := Object clone do(

            OperatorTable addAssignOperator("eq", "applyEqual")
            OperatorTable addAssignOperator("neq", "applyNotEqual")
            OperatorTable addAssignOperator("in", "applyIn")
            OperatorTable addAssignOperator("gt", "applyGreaterThan")
            OperatorTable addAssignOperator("gte", "applyGreaterThanEqual")
            OperatorTable addAssignOperator("lt", "applyLessThan")
            OperatorTable addAssignOperator("lte", "applyLessThanEqual")
            OperatorTable addAssignOperator("_and", "applyAnd")
            OperatorTable addAssignOperator("_or", "applyOr")
        
            ModelError := Exception clone do()
        
            whereList := List clone
            fieldList := List clone
            limitStr := nil
            offsetStr := nil
            orderStr := nil
        
            applyIn := method(key, val,
                if(val type == "List", 
                    whereIn := val join(",") asString asMutable
                    self whereList append(" #{key} in \(#{whereIn}\)" interpolate), 
                    ModelError raise("")
                )
                key
            )
        
            applyNotEqual := method(key, val, self whereList append(Sequence with(key, " != ", val asString));key)
        
            applyEqual := method(key, val,self whereList append(Sequence with(key, " = ", val asString));key)
        
            applyGreaterThan := method(key, val, self whereList append(Sequence with(key, " < ", val asString));key)
        
            applyGreaterThanEqual := method(key, val, self whereList append(Sequence with(key, " <= ", val asString));key)
        
            applyLessThan := method(key, val, self whereList append(Sequence with(key, " > ", val asString));key)
        
            applyLessThanEqual := method(key, val, self whereList append(Sequence with(key, " >= ", val asString));key)
        
            applyAnd := method(key, val,self whereList append("and");key)
        
            applyOr := method(key, val,self whereList append("or");key)
        
        
            selectBuild := method(name,
                fieldStr := self fieldList join(",")
                whereStr := self whereList reverse join(" ")
                select := Sequence with("select ", fieldStr, " from ", self asSnakeCase(name),  " where ", whereStr) asMutable
                if(self orderStr != nil, select = select appendSeq(self orderStr))
                if(self limitStr != nil, select = select appendSeq(self limitStr))
                if(self offsetStr != nil, select = select appendSeq(self offsetStr))
                select
            )
        
            asSnakeCase := method(val,
                re := Python import("re")
                s := re sub( "(.)([A-Z][a-z]+)", "\\1_\\2", val)
                re sub("([a-z0-9])([A-Z])", "\\1_\\2", s) asLowercase
            )
        )
    )

    field := method(self Builder fieldList = call message arguments;self)
        
    where := method(
        call message arguments foreach(arg,
            self Builder doString(arg asString)
        )
        self
    )
        
    limit := method(val,self Builder limitStr := Sequence with(" limit ", val asString);self)
        
    offset := method(val,self Builder offsetStr := Sequence with(" offset ", val asString);self)
        
    order := method(val,self Builder orderStr := Sequence with(" order by ", val asString);self)

    find := method(
        self offset(1)
        self limit(1)
        type println
        sql := self Builder selectBuild(type asString)
        sql println
    )

    findAll := method(
        sql := self Builder selectBuild(type asString)
        sql println
    )

    save := method(
        
    )

    transaction := method(bl,
        e := try(
            doMessage(bl)
        )
        e catch(Exception,
            Exception raise e
        )
    )
)

Form := Object clone do(
    init := method(
        self model := Model clone
    )

    save := method(
        
    )
)

App := Model clone
App type println
App field(id, name, status) where(status eq 1 _and  name neq "hoge" _or id in list(1,2,3,4)) find
