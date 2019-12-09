//
//  ListaNotasController.swift
//  iNotes
//
//  Created by Julia García Martínez on 05/12/2019.
//  Copyright © 2019 Julia García Martínez. All rights reserved.
//

import UIKit
import CoreData

class ListaNotasController: UITableViewController {
    
    // MARK: Properties
    var listaNotas : [Nota]!
    @IBOutlet var myTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let miContexto = miDelegate.persistentContainer.viewContext
        
        let request : NSFetchRequest<Nota> = NSFetchRequest(entityName:"Nota")
        
        if let notas = try? miContexto.fetch(request) {
            self.listaNotas = notas
        }
        
        self.myTableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaNotas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listaNotas[indexPath.row]
        
        let newCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        newCell.textLabel?.text = item.texto
        newCell.detailTextLabel?.text = item.libreta?.nombre
        
        return newCell
    }

}
