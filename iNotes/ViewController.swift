//
//  ViewController.swift
//  iNotes
//
//  Created by Julia García Martínez on 05/12/2019.
//  Copyright © 2019 Julia García Martínez. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: Properties
    let gestorPicker = GestorPicker()
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var mensajeLabel: UILabel!
    @IBOutlet weak var notaTextView: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    

    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self.gestorPicker
        self.pickerView.dataSource = self.gestorPicker
        self.gestorPicker.cargarLista()
        pickerView.setValue(UIColor.yellow, forKey: "textColor")
    }
    
    // MARK: Actions
    @IBAction func nuevaNotaAction(_ sender: Any) {
        self.fechaLabel.text = ""
        self.mensajeLabel.text = ""
        self.notaTextView.text = ""
    }
    
    @IBAction func guardarNotaAction(_ sender: Any) {
        
        guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let miContexto = miDelegate.persistentContainer.viewContext
        let numLibreta = self.pickerView.selectedRow(inComponent: 0)
        
        let nuevaNota = Nota(context:miContexto)
        nuevaNota.texto = self.notaTextView.text
        nuevaNota.fecha = Date()
        nuevaNota.libreta = self.gestorPicker.libretas[numLibreta]
        
        do {
            try miContexto.save()
            self.mensajeLabel.text = "Nota guardada"
            self.fechaLabel.text = DateFormatter.localizedString(from: nuevaNota.fecha!, dateStyle: .short, timeStyle: .medium)
        } catch let error as NSError {
            self.mensajeLabel.text = "\(error)"
            miContexto.refresh(nuevaNota, mergeChanges: false)
        } catch {
            print("Error al guardar el contexto: \(error)")
        }
    }
    
    @IBAction func nuevaLibretaAction(_ sender: Any) {
        let alert = UIAlertController(title: "Nueva libreta",
                                      message: "Escribe el nombre para la nueva libreta",
                                      preferredStyle: .alert)
        
        let crear = UIAlertAction(title: "Crear", style: .default) {
            action in
            let nombre = alert.textFields![0].text!
            
            guard let miDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let miContexto = miDelegate.persistentContainer.viewContext
            
            let nuevaLibreta = Libreta(context:miContexto)
            nuevaLibreta.nombre = nombre
            self.gestorPicker.libretas.append(nuevaLibreta)
            
            do {
                try miContexto.save()
                self.pickerView.reloadAllComponents()
            } catch let error as NSError {
                print("Error al guardar el contexto: \(error)")
            }
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel) {
            action in
        }
        alert.addAction(crear)
        alert.addAction(cancelar)
        alert.addTextField() { $0.placeholder = "Nombre"}
        
        self.present(alert, animated: true)
    }
    
    
}

