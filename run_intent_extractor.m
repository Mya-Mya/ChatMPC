function update_marker = run_intent_extractor(prompt)
arguments
    prompt string
end

import matlab.net.http.*
import matlab.net.http.field.*
import matlabl.net.*

request = RequestMessage;
request.Method = RequestMethod.POST;
request.Body = MessageBody(prompt);
uri = "http://127.0.0.1:3838";
response = send(request,uri);
    
responsedata = response.Body.Data;

update_marker = jsondecode(responsedata);
end