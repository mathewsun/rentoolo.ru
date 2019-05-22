//Вспомогательный функционал

function getParameterByName(name) {
    name = name.replace(/[\[]/, '\\\[').replace(/[\]]/, '\\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)'),
        results = regex.exec(location.search);
    return results == null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
}

function getUrlWithoutParameter(parameter) {
    //Get Query String from url
    fullQString = window.location.search.substring(1);

    paramCount = 0;
    queryStringComplete = '?';

    if (fullQString.length > 0) {
        //Split Query String into separate parameters
        paramArray = fullQString.split('&');

        //Loop through params, check if parameter exists.  
        for (i = 0; i < paramArray.length; i++) {
            currentParameter = paramArray[i].split('=');
            if (currentParameter[0] == parameter) //Parameter already exists in current url
            {
                //don't include existing (will be appended to end of url)
            }
            else //Existing unrelated parameter
            {
                if (paramCount > 0)
                    queryStringComplete = queryStringComplete + '&';

                queryStringComplete = queryStringComplete + paramArray[i];
                paramCount++;
            }
        }
    }

    return self.location.protocol + '//' + self.location.host + self.location.pathname + queryStringComplete;
}

function getUrlWithoutParameters() {
    return self.location.protocol + '//' + self.location.host + self.location.pathname;
}