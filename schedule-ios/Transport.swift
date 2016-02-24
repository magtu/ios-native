protocol Transport {
    func send(request r: Request, processor: Processor, listener: ResponseListener)
}