// See https://aka.ms/new-console-template for more information
using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Linq;


namespace week4
{
    class Pipeline
    {
        public Dictionary<string, int> sort(Dictionary<string, int> word_freqs)
        {
            int n = 0;
            var reversed_word_freqs = from entry in word_freqs orderby entry.Value descending select entry;//word_freqs.Reverse();
            //reversed_word_freqs
            Dictionary<string, int> final_word_freqs = new Dictionary<string, int>();
            final_word_freqs = reversed_word_freqs.ToDictionary(pair => pair.Key, pair => pair.Value);
            final_word_freqs.Remove(final_word_freqs.Keys.First());

            return final_word_freqs;
        }
        public void print_results(Dictionary<string, int> final_word_freqs)
        {
            foreach(var item in final_word_freqs.Take(25))
            {
                Console.WriteLine(item.Key + " - " + item.Value);
            }
        }
        public Dictionary<string, int> frequencies(List<string> cleaned_word_list){
            Dictionary<string, int> word_freqs = new Dictionary<string, int>();
            int count;
            foreach(string word in cleaned_word_list)
            {
                if (word_freqs.ContainsKey(word))
                {
                    word_freqs.TryGetValue(word, out count);
                    word_freqs[word] = count + 1;
                }
                else
                {
                    //word_freqs.TryGetValue(word, out count);
                    word_freqs[word] = 1;
                }
                count = 0;

            }
            return word_freqs;
        }         
                    
        public List<string> remove_stop_words(string[] word_list)
        {
            string sw_path = "stop_words.txt";
            string sw = File.ReadAllText(sw_path);
            string[] stopwords_list = sw.Split(",");

            char[] alpha = "abcdefghijklmnopqrstuvwxyz".ToCharArray();
            List<string> alpha_string = new List<string>();
            foreach(char c in alpha)
            {
                alpha_string.Add(c.ToString());
            }

            string[] stopwords = stopwords_list.Concat(alpha_string.ToArray()).ToArray();
            List<string> cleaned_word_list = new List<string>(); //word_list with stopwords removed
            foreach(string word in word_list)
            {
                if  (stopwords.Contains(word) == false)
                {
                    cleaned_word_list.Add(word);
                }

            }
            return cleaned_word_list;
        }
        public string[] scan(string data)
        {
            return (data.Split(" "));
        }
        public string filter_chars_and_normalize(string data)
        {
            Regex rgx = new Regex("[^a-z]");//[\\W_]+");
            data = rgx.Replace(data, " ");
            return data;
        }
        public string read_file(string path_to_file)
        {
            string data = "";
            data = File.ReadAllText(path_to_file);
            data = data.ToLower();
            return data;
        }
        public static void Main(string[] args)
        {
            Pipeline obj = new Pipeline();
            
            string[] arguments_recieved = Environment.GetCommandLineArgs();
            string ptf = arguments_recieved[1];
            
            obj.print_results(obj.sort(obj.frequencies(obj.remove_stop_words(obj.scan(obj.filter_chars_and_normalize(obj.read_file(ptf)))))));
            
        }
    }
}