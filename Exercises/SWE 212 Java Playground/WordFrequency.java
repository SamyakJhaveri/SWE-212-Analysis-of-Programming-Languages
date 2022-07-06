import java.io.*;
import java.util.*;
import java.util.regex.*;
import java.util.stream.Collectors;

public class WordFrequency
{   
    //Read entire file and returns a string with content
    public String readFile(String filename) throws IOException
    {   
        try
        {
            File f = new File(filename);
            try (Scanner sc = new Scanner(f)) 
            {
                sc.useDelimiter("\\Z");
                return sc.next();
            }
        }
        catch(FileNotFoundException e)
        {
            System.out.println("File doesn't exist in directory");
            return "";
        }   
    }

    public static void main(String[] args) throws IOException 
    {   
        WordFrequency wf = new WordFrequency();

        HashSet<String> stopwords=new HashSet<>();
        HashMap<String,Integer> map = new HashMap<>();

        //Stopwords read from file and stored in set
        String[] stop=wf.readFile("../stop_words.txt").split(",");
        for(String s:stop)
            stopwords.add(s);
        
        //Input filename via command line
        String filename=args[0];
        String content=wf.readFile("../"+filename).toLowerCase();
       
        //Using pattern and matcher to check if the word is of the regex type and create a counter of word frequency
        Matcher matcher = Pattern.compile("[a-z]{2,}").matcher(content);
        while (matcher.find()) 
        {   
            String word = matcher.group();
            if(!stopwords.contains(word))
            {
                if (!map.containsKey(word))
                    map.put(word, 1);
                else
                    map.put(word,map.get(word)+1);
           }
        }

        //Sort the hashmap by decreasing value of the number of times a word appears in the text
        Map<String, Integer> sortedMap = map.entrySet().stream().sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
        .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue, (e1, e2) -> e1, LinkedHashMap::new));

        //Get top 25 results and print on console
        int tokens = 0;
        for(String s:sortedMap.keySet())
        {
            if (tokens==25)
                break;
            System.out.println(s+" - "+sortedMap.get(s));
            tokens+=1;
        }
    }
}
