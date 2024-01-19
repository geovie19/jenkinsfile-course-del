## Get the list of all the plugins
* [jenkins-url][/script]
* Example: http://10.0.0.3:8080/script
* Hit enter, paste the code below and run

```groovy
def pluginList = new ArrayList(Jenkins.instance.pluginManager.plugins)
pluginList.sort { it.getShortName() }.each{
  plugin -> 
    println ("${plugin.getShortName()}: ${plugin.getVersion()}")
}
```
