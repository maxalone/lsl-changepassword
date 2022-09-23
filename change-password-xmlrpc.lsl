integer gListener;
string np;
string npr;
integer domanda;
string avatarclick;
string avatar;
key http_request_id;

string  RandomString(integer length)
{
    string characters = "abcdefghijklmnopqrstuvwxyz";
    string emp;
    integer p;
    integer q;
    do
    {
       q = (integer) llFrand(26);
       emp += llGetSubString(characters, q, q);
    }
    while(++p < length);                                                    
    return emp;
}


default
{
    state_entry()
    {
      llSetText("CAMBIA PASSWORD", <1.0,0.0,0.0>, 1);
    }
    
    touch_end(integer num_detected)
    {
        avatar = llDetectedName(0);
        integer channel = -13572468;
        gListener = llListen(channel, "", "", "");
        avatarclick=llDetectedKey(0);
        llTextBox(avatarclick, avatar +" scrivi la nuova pwd: ", channel);
    }
    


    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(gListener);
        message = llStringTrim(message,STRING_TRIM);
        np=message;
        llInstantMessage(avatarclick, avatar + " hai scritto: " + np);
        state esegue2;
    }
}

state esegue2
{
    state_entry(){
        integer channel = -13572468;
        gListener = llListen(channel, "", "", "");
        llTextBox(avatarclick, avatar + " riscrivi pwd: ", channel);
    }

    state_exit()
    {
       
    }

    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(gListener);
        message = llStringTrim(message,STRING_TRIM);
        npr=message;
        if (npr==np){
                llInstantMessage(avatarclick,avatar + " hai confermato: " + npr);
                state invia;
            } else {
                llInstantMessage(avatarclick,"NON HAI SCRITTO DUE VOLTE LA STESSA PASSWORD!");
                state default;
            }
        
        
     
    }
   
}

state invia
{
     state_entry(){
        string ritorno;
        string chiave=RandomString(10);
        string crypt = llXorBase64(llStringToBase64(npr),llStringToBase64(chiave));
         http_request_id =llHTTPRequest( "https://<your URL>",
                                          [ HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded" ],
                                          "avatar="+avatar+"&pass="+crypt+"&key="+chiave
                                          );
        llInstantMessage(avatarclick,"in esecuzione..."); //+ http_request_id
     
    }
    
    http_response(key request_id, integer status, list metadata, string body)
    {
        if (request_id == http_request_id)
        {
            if (body=="OK")
            {
                llInstantMessage(avatarclick,"PASSWORD CAMBIATA CON SUCCESSO!");
                }
            else
            {
                llInstantMessage(avatarclick,"ERRORE! la password non è stata modificata, avverti il proprietario del GRID");
                }
            
            state default;
        }
    }

    state_exit()
        {
        }
    }