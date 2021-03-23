/**
Drawer(
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              child:
              Text('Bars', style: TextStyle(fontSize: Settings.fontSize)),
              decoration: BoxDecoration(color: Colors.tealAccent),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: bars.length,
                itemBuilder: (BuildContext context, int index) {
                  Bar curBar = bars.getAt(index) ?? Bar();
                  return Dismissible(
                    direction: (DismissDirection.startToEnd),
                    key: ValueKey(curBar),
                    onDismissed: (direction) {
                      setState(() {
                        bars.delete(curBar.key);
                        if (bar == curBar) {
                          bar = bars.getAt(0) ?? Bar.empty();
                          vals.put('last', bar.key);
                          bar.save();
                        }
                        //curBar.save();
                      });
                    },
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete ${curBar.name}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  return Navigator.of(context).pop(false);
                                },
                                child: Text('Cancel')),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text('Confirm')),
                            ],
                          );
                        });
                    },
                    background: Container(
                      color: Colors.redAccent,
                    ),
                    child: Card(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      elevation: curBar == bar ? 0.5 : 4,
                      child: ListTile(
                        tileColor:
                        curBar == bar ? Colors.black12 : Colors.white,
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${bars.keys.elementAt(index)}  ::  ${bars.values
                                .elementAt(index)
                                .name}',
                              style: TextStyle(
                                fontSize: Settings.fontSize,
                                color: Colors.black)),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            vals.put('last', bar.key);
                            bar = bars.getAt(index) ?? bar;
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  );
                }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    bars.add(Bar.empty());
                    //bars.add(new Bar(name: 'Impuls'));
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('+ Add bar',
                    style: TextStyle(fontSize: Settings.fontSize)),
                )),
            ),
          ],
        ),
      ),*/
