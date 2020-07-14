## Charm Lifecycle

Broadly, eliding several details:

<div><a href='//sketchviz.com/@timClicks/30a4fa89d0d81cc7ccd9c385dd268bd0'><img src='https://sketchviz.com/@timClicks/30a4fa89d0d81cc7ccd9c385dd268bd0/7bff645aceafdb4525568f4cc6968b5ddcd8e25c.sketchy.png' style='max-width: 100%;'></a></div>

```dot
digraph G {
  graph [fontname = "Ubuntu "];
  node [fontname = "Ubuntu Mono"];
  edge [fontname = "Handlee"];

  bgcolor=transparent;

  subgraph cluster_charm {
    
    label="Hook Execution";
 
    install -> start -> "Main Loop" -> stop -> remove;
  }
  
//   subgraph cluster_mainloop {
//       label="Main loop";
      
//       "Config Change" -> "Relation Hooks" -> "Storage Hooks"
//       "Leadership Hooks"
//       update_status -> update_status;
//   }
  
  begin -> install;
  remove -> end;
  
  "Main Loop" [shape=square] 

  begin [shape=circle style=filled label=""];
  end [shape=doublecircle style=filled label=""];
}

```


----


# Triggers

| Event | Hook(s) Triggered  | Extra details
|----|----|---|
| Timer  | <li> `update-status` | Frequency set by `update-status-hook-interval` configuration parameter. See [Configuring Models](https://jaas.ai/docs/configuring-models)
| Timer  | <li> `collect-metrics` | 
| `juju attach-storage <unit> <name>` | <li> `<name>-storage-attached`
| `juju detach-storage <name>` | <li> `<name>-storage-detaching`
| Machine startup | <li> `start` | Coming in Juju 2.8.0.
| `juju add-unit` | <li> `<rel>-relation-joined` <li> `<rel>-relation-changed` | Only the first unit of a new application triggers a `-relation-joined` hook.
