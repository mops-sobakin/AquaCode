use serde::{Deserialize, Serialize};
use std::fs;
use tauri::command;

#[derive(Serialize, Deserialize, Clone, Debug)]
struct FileNode {
    name: String,
    path: String,
    is_dir: bool,
    children: Vec<FileNode>,
}

#[command]
fn read_directory(path: String) -> Result<Vec<FileNode>, String> {
    let entries = fs::read_dir(&path).map_err(|e| format!("Cannot read directory: {}", e))?;
    let mut nodes = Vec::new();
    for entry in entries {
        let entry = entry.map_err(|e| e.to_string())?;
        let metadata = entry.metadata().map_err(|e| e.to_string())?;
        let name = entry.file_name().to_string_lossy().to_string();
        let full_path = entry.path().to_string_lossy().to_string();
        let is_dir = metadata.is_dir();
        if name.starts_with('.') { continue; }
        let children = if is_dir { Vec::new() } else { Vec::new() };
        nodes.push(FileNode { name, path: full_path, is_dir, children });
    }
    nodes.sort_by(|a, b| {
        if a.is_dir && !b.is_dir { std::cmp::Ordering::Less }
        else if !a.is_dir && b.is_dir { std::cmp::Ordering::Greater }
        else { a.name.to_lowercase().cmp(&b.name.to_lowercase()) }
    });
    Ok(nodes)
}

#[command]
fn read_file(path: String) -> Result<String, String> {
    fs::read_to_string(&path).map_err(|e| format!("Cannot read file: {}", e))
}

#[command]
fn write_file(path: String, content: String) -> Result<(), String> {
    if let Some(parent) = std::path::Path::new(&path).parent() {
        fs::create_dir_all(parent).map_err(|e| e.to_string())?;
    }
    fs::write(&path, &content).map_err(|e| format!("Cannot write file: {}", e))
}

#[command]
fn create_file(path: String) -> Result<(), String> {
    if let Some(parent) = std::path::Path::new(&path).parent() {
        fs::create_dir_all(parent).map_err(|e| e.to_string())?;
    }
    fs::write(&path, "").map_err(|e| e.to_string())
}

#[command]
fn create_directory(path: String) -> Result<(), String> {
    fs::create_dir_all(&path).map_err(|e| e.to_string())
}

#[command]
fn rename_item(old_path: String, new_path: String) -> Result<(), String> {
    if let Some(parent) = std::path::Path::new(&new_path).parent() {
        fs::create_dir_all(parent).map_err(|e| e.to_string())?;
    }
    fs::rename(&old_path, &new_path).map_err(|e| e.to_string())
}

#[command]
fn delete_item(path: String) -> Result<(), String> {
    let metadata = fs::metadata(&path).map_err(|e| e.to_string())?;
    if metadata.is_dir() {
        fs::remove_dir_all(&path).map_err(|e| e.to_string())
    } else {
        fs::remove_file(&path).map_err(|e| e.to_string())
    }
}

#[command]
fn get_home_dir() -> String {
    std::env::var("USERPROFILE").unwrap_or_else(|_| "C:\\".to_string())
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            read_directory,
            read_file,
            write_file,
            create_file,
            create_directory,
            rename_item,
            delete_item,
            get_home_dir
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
