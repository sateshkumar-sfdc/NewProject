global class DebugHttpTrace implements ENSX.EnosixFramework.HttpTrace {
         
    Map<string, string> request;
    public void onRequest(Map<string, string> args) {
        this.request= args;
    }
     
    public void onResponse(Map<string, string> args) {
        this.request.putAll(args);
        System.debug(this.request);
    }
}