public class Palaura.Core.Dict {
    public async string get_entries (string text) throws GLib.Error {
        var settings = AppSettings.get_default ();
        string dict = settings.dict_lang;
        settings.changed.connect (() => {
            if (settings.dict_lang == "en") {
                dict = "en";
            } else if (settings.dict_lang == "es") {
                dict = "es";
            }
        });

        string uri = @"https://od-api.oxforddictionaries.com:443/api/v1/entries/$dict/$text";

        string response = "";

        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", uri);
        Soup.MessageHeaders headers = message.request_headers;
        headers.append ("Accept","application/json");
        headers.append ("app_id","db749a02");
        headers.append ("app_key","bf44ba104ce6d42d444db54fa878a52b");

        session.queue_message (message, (sess, mess) => {
            response = (string) mess.response_body.data;

            Idle.add (get_entries.callback);
        });

        yield;
        return response;
    }

    public async Core.Definition[] search_text (string word) {
        Core.Definition[] definitions = {};

        try {
            var parser = new Json.Parser();
            parser.load_from_data (yield get_entries (word));

            var root_object = parser.get_root().get_object ();
            var results = root_object.get_array_member("results");
            var obj_results = results.get_object_element(0);
            var lexentry = obj_results.get_array_member("lexicalEntries");

            foreach (var w in lexentry.get_elements())
                definitions += Core.Definition.parse_json (w.get_object ());
        } catch (Error e) {
            warning (e.message);
        }

        return definitions;
    }

}
