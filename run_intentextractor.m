% Requires:
% prompt - prompt p given by user H.
% Run Intent Extractor server.

import matlab.net.http.*
import matlab.net.http.field.*
import matlab.net.*

% Create Request
request = RequestMessage;
request.Method = RequestMethod.POST;
request.Body = MessageBody(prompt);

% Send Request
uri = URI("http://127.0.0.1:3838/");
response = send(request,uri);

% Recieve Response
classname = response.Body.Data