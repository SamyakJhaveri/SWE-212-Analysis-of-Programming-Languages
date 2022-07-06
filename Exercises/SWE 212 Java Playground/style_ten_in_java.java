import java.io.*;
import java.util.*;
import java.util.regex.*;
import java.util.stream.Collectors;
import java.lang.reflect.Method;

class TFTheOne
{  
  Object val;

  TFTheOne(Object val)
  {
    this.val=val;
  }

  public TFTheOne bind(Method method)
  {  
    try
      {
        this.val = method.invoke(new Ten(),this.val);
        return this;
      }
    catch(Exception e)
      {
        System.out.println(e);
        return this;
      }
  }

  public void print()
  {
    System.out.println(val);
  }
}

class Ten
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

    
     public String readTextFile(String filename) throws IOException
    {   
        String content=readFile(filename).toLowerCase();
        return content;
    }
    
    //Using pattern and matcher to check if the word is of the regex type and create a counter of word frequency
    public HashMap<String,Integer> wordCount(String content)
    {  
        HashSet<String> stopwords=new HashSet<>();
        try{
        String[] stop=readFile("../stop_words.txt").split(",");
        for(String s:stop)
            stopwords.add(s);
          }
      catch(Exception e)
          {
            System.out.println("File doesn't exist in directory");
          }
        HashMap<String,Integer> map = new HashMap<>();
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
        return map;
    }
    
     //Sort the hashmap by decreasing value of the number of times a word appears in the text
    public HashMap<String,Integer> sortMap(HashMap<String,Integer> map)
    {   
        HashMap<String, Integer> sortedMap = map.entrySet().stream().sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
        .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue, (e1, e2) -> e1, LinkedHashMap::new));
      return sortedMap;
    }
  
    public String top25Words(HashMap<String,Integer> sortedMap)
    {
        //Get top 25 results and print on console
        String str="";
        int tokens = 0;
        for(String s:sortedMap.keySet())
        {
            if (tokens==25)
                break;
            str+=s+" - "+sortedMap.get(s)+"\n";
            tokens+=1;
        }
      return str;
    }

    public static void main(String[] args) throws IOException,NoSuchMethodException 
    {   
new TFTheOne("../"+args[0])    .bind(Ten.class.getDeclaredMethod("readTextFile",String.class)) .bind(Ten.class.getDeclaredMethod("wordCount",String.class))
.bind(Ten.class.getDeclaredMethod("sortMap",HashMap.class)) .bind(Ten.class.getDeclaredMethod("top25Words",HashMap.class))
.print();
    }
}