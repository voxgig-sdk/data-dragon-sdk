package core

type DataDragonError struct {
	IsDataDragonError bool
	Sdk              string
	Code             string
	Msg              string
	Ctx              *Context
	Result           any
	Spec             any
}

func NewDataDragonError(code string, msg string, ctx *Context) *DataDragonError {
	return &DataDragonError{
		IsDataDragonError: true,
		Sdk:              "DataDragon",
		Code:             code,
		Msg:              msg,
		Ctx:              ctx,
	}
}

func (e *DataDragonError) Error() string {
	return e.Msg
}
