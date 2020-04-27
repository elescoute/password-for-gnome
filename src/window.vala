/* window.vala
 *
 * Copyright 2020 Emilien
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

//VARIABLES GLOBALES
string randomPassword;
string pass;
string passwordCourt;
string dossierConfig;
bool quitterAppli;
bool attendreAvanDeFermer;
bool notificationEffacement;
bool phosh;
int largeur;
int chgt;
int champ;

namespace Password {
	[GtkTemplate (ui = "/org/emilien/Password/window.ui")]

	public class Window : Gtk.ApplicationWindow {

		//WIDGETS

		[GtkChild] Gtk.HeaderBar headerbar;
		[GtkChild] Gtk.Stack fenetre;
		[GtkChild] Gtk.Box fenetreCalculateur;
		[GtkChild] Gtk.Box fenetreGenerateur;
		[GtkChild] Gtk.ScrolledWindow fenetreScroll;
		[GtkChild] Gtk.Revealer revealBarre;
		[GtkChild] Gtk.Revealer revealHaut;
		[GtkChild] Gtk.Revealer revealBas;
		[GtkChild] Gtk.Box barre;
		[GtkChild] Gtk.Image iconeBoutonNettoyer;
		[GtkChild] Gtk.Button boutonNettoyer;
		[GtkChild] Gtk.Revealer revealCopier;
		[GtkChild] Gtk.Button boutonCopier;
		[GtkChild] Gtk.Switch switchMask;
		[GtkChild] Gtk.Image iconeSwitchMask;
		[GtkChild] Gtk.ModelButton boutonPreferences;
		[GtkChild] Gtk.ModelButton boutonPropos;
		[GtkChild] Gtk.ModelButton boutonQuitter;
		[GtkChild] Gtk.Image iconeBoutonMenuMode;
		[GtkChild] Gtk.Image iconeCalculateur;
		[GtkChild] Gtk.Image iconeGenerateur;
		[GtkChild] Gtk.Image iconeReglages;
		[GtkChild] Gtk.ModelButton boutonModeCalculateur;
		[GtkChild] Gtk.ModelButton boutonModeGenerateur;
		[GtkChild] Gtk.ModelButton boutonModeReglages;
		[GtkChild] Gtk.MenuButton boutonMenuMode;
		[GtkChild] Gtk.Entry texteAlias;
		[GtkChild] Gtk.Entry texteSecret;
		[GtkChild] Gtk.Button boutonAleatoire;
		[GtkChild] Gtk.Label motDePasse;
		[GtkChild] Gtk.Label motDePasseAleatoire;
		[GtkChild] Gtk.ComboBoxText comboHachage;
		[GtkChild] Gtk.Switch switchConversion;
		[GtkChild] Gtk.Entry texteSalage;
		[GtkChild] Gtk.Entry preAlias;
		[GtkChild] Gtk.Switch switchQuitter;
		[GtkChild] Gtk.Switch switchNotifications;
		[GtkChild] Gtk.Scale scaleLongueur;
		[GtkChild] Gtk.Switch switchMinuscules;
		[GtkChild] Gtk.Switch switchMajuscules;
		[GtkChild] Gtk.Switch switchChiffres;
		[GtkChild] Gtk.Switch switchSpeciaux;
		[GtkChild] Gtk.Switch switchSuppression;
		[GtkChild] Gtk.Scale scaleTemps;

		//FIN WIDGETS

        public Window (Gtk.Application app) {
			Object (application: app);

            //INITIALISATION VARIABLES

            passwordCourt = "";
            randomPassword = "";
            pass = "";
            dossierConfig = "";
            quitterAppli=false;
            attendreAvanDeFermer=false;
            notificationEffacement=false;
            phosh=false;
            largeur=-1;
            chgt=-1;
            champ=-1;

            //MODIF WIDGETS


            revealHaut.add(barre);
            texteAlias.set_alignment((float) 0.5);
            texteSecret.set_alignment((float) 0.5);
            boutonPreferences.hide();
            motDePasseAleatoire.set_label("");
            boutonModeCalculateur.set_image(iconeCalculateur);
            boutonModeCalculateur.set_always_show_image(true);
            boutonModeCalculateur.set_label(_(" Calculator"));
            boutonModeGenerateur.set_image(iconeGenerateur);
            boutonModeGenerateur.set_always_show_image(true);
            boutonModeGenerateur.set_label(_(" Generator"));
            boutonModeReglages.set_image(iconeReglages);
            boutonModeReglages.set_always_show_image(true);
            boutonModeReglages.set_label(_(" Settings"));

            //CONFIGURATION

            dossierConfig = GLib.Environment.get_variable("XDG_CONFIG_HOME");
            lectureConfig();

			//CONNEXIONS

            size_allocate.connect(chgtTaille);
            hide.connect(quitter);
            boutonModeCalculateur.clicked.connect(basculModeCalculateur);
            boutonModeGenerateur.clicked.connect(basculModeGenerateur);
            boutonModeReglages.clicked.connect(basculModeReglages);
            boutonAleatoire.clicked.connect(generation);
            switchMask.notify["active"].connect(basculMask);
            texteAlias.changed.connect(texteChange);
            texteAlias.icon_press.connect(() => {champ=0;on_icon_pressed();});
            texteAlias.activate.connect(entreTexteAlias);
            texteSecret.changed.connect(texteChange);
            texteSecret.icon_press.connect(() => {champ=1;on_icon_pressed();});
            texteSecret.activate.connect(entreTexteSecret);
            boutonNettoyer.clicked.connect(nettoyer);
            boutonCopier.clicked.connect(copier);
            boutonPropos.clicked.connect(aPropos);
            comboHachage.changed.connect(() => {chgt=1;chgtReglages();});
            switchConversion.notify["active"].connect(() => {chgt=1;chgtReglages();});
            texteSalage.changed.connect(() => {chgt=1;chgtReglages();});
            texteSalage.icon_press.connect(() => {champ=2;on_icon_pressed();});
            preAlias.changed.connect(chgtPreAlias);
            preAlias.icon_press.connect(() => {champ=3;on_icon_pressed();});
            switchQuitter.notify["active"].connect(() => {chgt=0;chgtReglages();});
            switchNotifications.notify["active"].connect(() => {chgt=0;chgtReglages();});
            scaleLongueur.value_changed.connect(() => {chgt=2;chgtReglages();});
            switchMinuscules.notify["active"].connect(basculSwitchMinuscules);
            switchMajuscules.notify["active"].connect(basculSwitchMajuscules);
            switchChiffres.notify["active"].connect(() => {chgt=2;chgtReglages();});
            switchSpeciaux.notify["active"].connect(() => {chgt=2;chgtReglages();});
            switchSuppression.notify["active"].connect(() => {chgt=0;chgtReglages();});
            scaleTemps.value_changed.connect(() => {chgt=0;chgtReglages();});
            boutonQuitter.clicked.connect(quitter);

		}

		//SUBROUTINES

        void basculMask()
        {
            if(switchMask.get_active()==true){
                iconeSwitchMask.set_from_icon_name("view-reveal-symbolic",MENU);
                if(texteAlias.get_text()!="" && texteSecret.get_text()!="") motDePasse.set_label(calculMask(switchMask.get_state()));
                if(motDePasseAleatoire.get_text()!="") motDePasseAleatoire.set_label(mdpAleatoire(false, (int) scaleLongueur.get_value(), switchMask.get_state(),//
             switchMinuscules.get_state(), switchMajuscules.get_state(), switchChiffres.get_state(),//
             switchSpeciaux.get_state())); //ON CHANGE L'AFFICHAGE DU MOT DE PASSE ALEATOIRE
            }
            else{
                iconeSwitchMask.set_from_icon_name("view-conceal-symbolic",MENU);
                if(texteAlias.get_text()!="" && texteSecret.get_text()!="") motDePasse.set_label(calculMask(switchMask.get_state()));
                if(motDePasseAleatoire.get_text()!="") motDePasseAleatoire.set_label(mdpAleatoire(false, (int) scaleLongueur.get_value(), switchMask.get_state(),//
             switchMinuscules.get_state(), switchMajuscules.get_state(), switchChiffres.get_state(),//
             switchSpeciaux.get_state())); //ON CHANGE L'AFFICHAGE DU MOT DE PASSE ALEATOIRE
            }
        }

        void basculModeCalculateur()
        {
            iconeBoutonMenuMode.set_from_icon_name("accessories-calculator-symbolic", BUTTON);
            headerbar.set_subtitle(_("Password calculator"));
            //modeCalculateur=true;modeGenerateur=false;
            if(passwordCourt=="" && revealCopier.get_child_revealed()) revealCopier.set_reveal_child(false);
            if(passwordCourt!="" && !revealCopier.get_child_revealed()) revealCopier.set_reveal_child(true);
            fenetre.set_visible_child(fenetreCalculateur);

        }

        void basculModeGenerateur()
        {
            iconeBoutonMenuMode.set_from_icon_name("applications-science-symbolic", BUTTON);
            headerbar.set_subtitle(_("Password generator"));
            if(pass=="" && revealCopier.get_child_revealed()) revealCopier.set_reveal_child(false);
            if(pass!="" && !revealCopier.get_child_revealed()) revealCopier.set_reveal_child(true);
            fenetre.set_visible_child(fenetreGenerateur);
        }

        void basculModeReglages()
        {
            iconeBoutonMenuMode.set_from_icon_name("applications-system-symbolic", BUTTON);
            headerbar.set_subtitle(_("Settings"));
            fenetre.set_visible_child(fenetreScroll);
            revealCopier.set_reveal_child(false);
        }

        void texteChange()
        {
             if(texteAlias.get_text()!="" || texteSecret.get_text()!=""){ //SI AU MOINS UN DES DEUX REMPLI
                   iconeBoutonNettoyer.set_from_icon_name("user-trash-full-symbolic", BUTTON);
                   if(texteAlias.get_text()!="" && texteAlias.get_icon_name(SECONDARY)==null) texteAlias.set_icon_from_icon_name(SECONDARY,"edit-delete-symbolic");
                   if(texteSecret.get_text()!="" && texteSecret.get_icon_name(SECONDARY)==null) texteSecret.set_icon_from_icon_name(SECONDARY,"edit-delete-symbolic");
               }
             if(texteAlias.get_text()=="" || texteSecret.get_text()==""){ //SI AU MOINS UN DES DEUX VIDES
                    motDePasse.set_label(_("your password"));
                    passwordCourt="";
                    revealCopier.set_reveal_child(false);
                    if(texteAlias.get_text()=="" && texteAlias.get_icon_name(SECONDARY)!=null) texteAlias.set_icon_from_icon_name(SECONDARY,null);
                    if(texteSecret.get_text()=="" && texteSecret.get_icon_name(SECONDARY)!=null) texteSecret.set_icon_from_icon_name(SECONDARY,null);
                    }

             if(texteAlias.get_text()=="" && texteSecret.get_text()==""){ //SI LES DEUX VIDES
                   if(motDePasseAleatoire.get_label()=="") iconeBoutonNettoyer.set_from_icon_name("user-trash-symbolic", BUTTON);
                   motDePasse.set_label(_("your password"));
                   passwordCourt="";
                   revealCopier.set_reveal_child(false);
               }
             if(texteAlias.get_text()!="" && texteSecret.get_text()!=""){ //SI LES DEUX REMPLIS
                   calcul();
               }

        }

        void on_icon_pressed()
        {
            if(champ==0) texteAlias.set_text("");
            if(champ==1) texteSecret.set_text("");
            if(champ==2) texteSalage.set_text("");
            if(champ==3) preAlias.set_text("");
        }

        void entreTexteAlias()
        {
            //FOCUS SUR ENTREE SECRET
            texteSecret.grab_focus();
        }

        void calcul()
        {
            motDePasse.set_label(mdpCalcul(texteAlias.get_text(), texteSecret.get_text(), switchMask.get_state(),//
                comboHachage.get_active(), switchConversion.get_state(), (int) scaleLongueur.get_value(),//
                texteSalage.get_text(), switchMinuscules.get_state(), switchMajuscules.get_state(),//
                switchChiffres. get_state(), switchSpeciaux.get_state() ));
            revealCopier.set_reveal_child(true);
        }

        void generation()
        {
            iconeBoutonNettoyer.set_from_icon_name("user-trash-full-symbolic", BUTTON);
            motDePasseAleatoire.set_label(mdpAleatoire(true, (int) scaleLongueur.get_value(), switchMask.get_state(),//
                switchMinuscules.get_state(), switchMajuscules.get_state(), switchChiffres.get_state(),//
                switchSpeciaux.get_state()));
            revealCopier.set_reveal_child(true);
        }

        void chgtPreAlias()
        {
            texteAlias.set_text(preAlias.get_text());
            chgt=0;
            chgtReglages();
        }

        void chgtReglages()
        {
            // CHGT=0 ; ENREGISTREMENT UNIQUEMENT
            // CHGT=1 ; ENREGISTREMENT + CALCUL
            // CHGT=2 ; ENREGISTREMENT + CALCUL + ALEATOIRE

            ecritureConfig();

            if(preAlias.get_text()!="" && preAlias.get_icon_name(SECONDARY)==null) preAlias.set_icon_from_icon_name(SECONDARY,"edit-delete-symbolic");
            if(preAlias.get_text()=="" && preAlias.get_icon_name(SECONDARY)!=null) preAlias.set_icon_from_icon_name(SECONDARY,null);
            if(texteSalage.get_text()!="" && texteSalage.get_icon_name(SECONDARY)==null) texteSalage.set_icon_from_icon_name(SECONDARY,"edit-delete-symbolic");
            if(texteSalage.get_text()=="" && texteSalage.get_icon_name(SECONDARY)!=null) texteSalage.set_icon_from_icon_name(SECONDARY,null);

            if(chgt>=1 && texteAlias.get_text()!="" && texteSecret.get_text()!=""){
                motDePasse.set_label(mdpCalcul(texteAlias.get_text(), texteSecret.get_text(), switchMask.get_state(),//
                    comboHachage.get_active(), switchConversion.get_state(), (int) scaleLongueur.get_value(),//
                    texteSalage.get_text(), switchMinuscules.get_state(), switchMajuscules.get_state(),//
                    switchChiffres. get_state(), switchSpeciaux.get_state() ));
            }
            if(chgt==2 && motDePasseAleatoire.get_text()!=""){
                motDePasseAleatoire.set_label(mdpAleatoire(false, (int) scaleLongueur.get_value(), switchMask.get_state(),//
                    switchMinuscules.get_state(), switchMajuscules.get_state(), switchChiffres.get_state(),//
                    switchSpeciaux.get_state())); //ON CHANGE L'AFFICHAGE DU MOT DE PASSE ALEATOIRE
            }
        }

        void basculSwitchMinuscules()
        {
            if(switchMinuscules.get_state() && switchMajuscules.get_state()){
                switchMajuscules.set_state(false);
            }
            else{
                chgt=2;
                chgtReglages();
            }
        }

        void basculSwitchMajuscules()
        {
            if(switchMajuscules.get_state() && switchMinuscules.get_state()){
                switchMinuscules.set_state(false);
            }
            else{
                chgt=2;
                chgtReglages();
            }
        }

        void lectureConfig()
        {
            File fichierConfig = File.new_for_path(dossierConfig + "/password.conf");

            if(fichierConfig.query_exists()){
                var dis = new DataInputStream (fichierConfig.read ());
                texteSalage.set_text(dis.read_line(null));
                preAlias.set_text(dis.read_line(null));
                comboHachage.set_active(dis.read_line(null).to_int());
                switchConversion.set_state(bool.parse(dis.read_line(null)));
                switchQuitter.set_state(bool.parse(dis.read_line(null)));
                scaleLongueur.set_value(dis.read_line(null).to_int());
                switchMinuscules.set_state(bool.parse(dis.read_line(null)));
                switchMajuscules.set_state(bool.parse(dis.read_line(null)));
                switchChiffres.set_state(bool.parse(dis.read_line(null)));
                switchSpeciaux.set_state(bool.parse(dis.read_line(null)));
                switchSuppression.set_state(bool.parse(dis.read_line(null)));
                scaleTemps.set_value(dis.read_line(null).to_int());
                switchNotifications.set_state(bool.parse(dis.read_line(null)));
            }

            //PRE-REMPLISSAGE ALIAS
            if(preAlias.get_text()!=""){
                texteAlias.set_text(preAlias.get_text());
                texteSecret.grab_focus();
                texteAlias.set_icon_from_icon_name(SECONDARY,"edit-delete-symbolic");
                preAlias.set_icon_from_icon_name(SECONDARY,"edit-delete-symbolic");
            }
            if(texteSalage.get_text()!="") texteSalage.set_icon_from_icon_name(SECONDARY,"edit-delete-symbolic");
        }

        void ecritureConfig()
        {
            string fichierConfig = dossierConfig + "/password.conf";

            string config = "";
            config += texteSalage.get_text() + "\n";
            config += preAlias.get_text() + "\n";
            config += comboHachage.get_active().to_string() + "\n";
            config += switchConversion.get_state().to_string() + "\n";
            config += switchQuitter.get_state().to_string() + "\n";
            config += scaleLongueur.get_value().to_string() + "\n";
            config += switchMinuscules.get_state().to_string() + "\n";
            config += switchMajuscules.get_state().to_string() + "\n";
            config += switchChiffres.get_state().to_string() + "\n";
            config += switchSpeciaux.get_state().to_string() + "\n";
            config += switchSuppression.get_state().to_string() + "\n";
            config += scaleTemps.get_value().to_string() + "\n";
            config += switchNotifications.get_state().to_string() + "\n";
            FileUtils.set_contents (fichierConfig, config);
        }

        void aPropos()
        {
            //Gdk.Pixbuf *password_logo = new Gdk.Pixbuf.from_resource ("/org/emilien/password/org.emilien.password.svg");
            const string COPYRIGHT = "Copyright \xc2\xa9 2020 Emilien Lescoute.\n";
            const string AUTHORS[] = {
                "Emilien Lescoute",
                null
            };
            var program_name = "Password";
            Gtk.show_about_dialog (this,
                               "program-name", program_name,
                               "logo-icon-name", Config.APP_ID,
                               "version", Config.VERSION,
                               "comments", "Calculator and random generator password for GNOME.",
                               "copyright", COPYRIGHT,
                               "authors", AUTHORS,
                               "license-type", Gtk.License.LGPL_3_0,
                               "wrap-license", false,
                               "website", "https://gitlab.com/elescoute/password-for-gnome-vala",
                               "translator-credits", "translator-credits",
                               null);
            }

        void quitter()
        {
            //close();
            if(!attendreAvanDeFermer) get_application().quit();
            if(attendreAvanDeFermer) quitterAppli=true;
        }

        void effacement()
        {
            clipboard("");

            if(switchNotifications.get_state()) envoiNotification(_("Password deleted"));//SI FENETRE HIDE, PROGRAMME S'ARRÊTE TOUT DE SUITE (???)

            attendreAvanDeFermer=false;
            if(quitterAppli) GLib.Timeout.add(1000, () => {quitter(); return false;});
        }

        void nettoyer()
        {
            iconeBoutonNettoyer.set_from_icon_name("user-trash-symbolic", BUTTON);
            clipboard("");
            texteAlias.set_text("");
            texteSecret.set_text("");
            passwordCourt="";
            randomPassword="";
            motDePasse.set_label(_("your password"));
            motDePasseAleatoire.set_label("");
            revealCopier.set_reveal_child(false);
        }

        void copier()
        {
            if(fenetre.get_visible_child_name()=="pageCalculateur" && passwordCourt!="") clipboard(passwordCourt);
            if(fenetre.get_visible_child_name()=="pageGenerateur" && pass!="") clipboard(pass);

            if(switchNotifications.get_state()) envoiNotification(_("Password copied to the clipboard"));

            if(switchSuppression.get_state()){
                if(!quitterAppli) attendreAvanDeFermer=true;//AU CAS OU L'UTILISATEUR VEUILLE FERMER L'APPLI APRES AVOIR APPUYER SUR COPIE
                GLib.Timeout.add((uint) scaleTemps.get_value()*1000, () => {effacement(); return false;});
            }

            if(quitterAppli) hide();
        }

        void entreTexteSecret()
        {

            if(passwordCourt!=""){
                if(switchQuitter.get_state()){
                    quitterAppli=true;
                    attendreAvanDeFermer=true;
                }

                //COPIE MOT DE PASSE
                copier();
            }
        }

        void chgtTaille(Gtk.Allocation allocation)
        {
            int width;
            int height;
            get_size(out width, out height);
            if(width!=largeur){
                largeur=width;
                if(largeur<=450 && !phosh){
                    phosh=true;
                    revealBarre.set_reveal_child(true);
                    revealHaut.set_reveal_child(false);
                    revealHaut.remove(barre);
                    revealBas.add(barre);
                    revealBas.set_reveal_child(true);
                    headerbar.remove(boutonMenuMode);
                    headerbar.pack_start(boutonMenuMode);
                }
                if(largeur>450 && phosh){
                    phosh=false;
                    revealBarre.set_reveal_child(false);
                    revealBas.set_reveal_child(false);
                    revealBas.remove(barre);
                    revealHaut.add(barre);
                    revealHaut.set_reveal_child(true);
                    headerbar.remove(boutonMenuMode);
                    headerbar.pack_end(boutonMenuMode);
                }
            }
        }

        void envoiNotification(string id)
        {
            stdout.puts("Notification\n");
            var notification = new GLib.Notification ("Password");
            notification.set_body (id);
            var gicon = GLib.Icon.new_for_string ("dialog-password");
            notification.set_icon (gicon);
            GLib.Application.get_default ().send_notification (null, notification);
        }

        void clipboard(string id)
        {
            Gdk.Display display = Gdk.Display.get_default ();
            Gtk.Clipboard refClipboard = Gtk.Clipboard.get_for_display (display, Gdk.SELECTION_CLIPBOARD);
            refClipboard.set_text(id, id.length);
        }

	}   //FIN WINDOW
}   //FIN NAMESPACE
