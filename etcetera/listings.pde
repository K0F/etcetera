
String[] getFiles(String path){
  
  println("Listing all filenames in a directory: "+path);
  String[] filenames = listFileNames(path);
  return filenames;
}

// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}
