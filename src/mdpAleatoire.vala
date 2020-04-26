string mdpAleatoire(bool generate, int length, bool mask, bool remLower, bool remUpper, bool remNum, bool remSpec)
{



    string alphanum = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/*-+=$@:;.,!?~&#|<>";

    if(generate){
        char s[30];
        for (int i = 0; i < 30; ++i) {
            s[i] =alphanum[Random.int_range(0,alphanum.length - 1)];
        }

        s[30] = 0;

        randomPassword = (string) s;//.to_string (); //MOT DE PASSE LONG A RE-MODIFIER
    }
    pass = randomPassword.substring(0,length);

      //REMOVE NUMERIC

      if(remNum) {
        pass = pass.replace("0", "+");
        pass = pass.replace("1", "/");
        pass = pass.replace("2", "=");
        pass = pass.replace("3", "A");
        pass = pass.replace("4", "B");
        pass = pass.replace("5", "C");
        pass = pass.replace("6", "D");
        pass = pass.replace("7", "E");
        pass = pass.replace("8", "F");
        pass = pass.replace("9", "G");
      }

      //REMOVE SPECIAL

      if(remSpec) {
        pass = pass.replace("+", "A");
        pass = pass.replace("/", "B");
        pass = pass.replace("*", "C");
        pass = pass.replace("-", "D");
        pass = pass.replace("/", "E");
        pass = pass.replace("=", "F");
        pass = pass.replace("$", "G");
        pass = pass.replace("@", "H");
        pass = pass.replace(":", "I");
        pass = pass.replace(";", "J");
        pass = pass.replace(".", "K");
        pass = pass.replace(",", "L");
        pass = pass.replace("!", "M");
        pass = pass.replace("?", "N");
        pass = pass.replace("~", "O");
        pass = pass.replace("&", "P");
        pass = pass.replace("#", "Q");
        pass = pass.replace("|", "R");
        pass = pass.replace("<", "S");
        pass = pass.replace(">", "T");
      }

      //REMOVE LOWER

      if(remLower) pass = pass.ascii_down();

      //REMOVE UPPER

      if(remUpper) pass = pass.ascii_up();


      //randomPasswordQ.clear();
      //randomPasswordQMask.clear();

      //randomPasswordQ = QString::fromStdString(pass);//MOT DE PASSE APRES FILTRE A COPIER

      //MASQUAGE

        string randomPasswordMask;
        randomPasswordMask = "";

      int nbMask=1;
      if(length>7) nbMask=2;
      if(length>10) nbMask=3;
      for(int i=0; i<length; i++){
        if(i<nbMask || i>=length-nbMask){
          randomPasswordMask += pass.substring(i,1);
        }
        else{
          randomPasswordMask += "\u25CF";
        }}



      string output;
      output = "";

      if(!mask) output = randomPasswordMask;
      if(mask) output = pass;

      return output;

}
