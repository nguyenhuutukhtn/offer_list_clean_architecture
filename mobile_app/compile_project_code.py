import os

def is_dart_file(filename):
    dart_extensions = ('.dart', '.yaml', '.json')
    excluded_files = ('package-lock.json', '.packages', '.flutter-plugins', '.flutter-plugins-dependencies')
    return filename.lower().endswith(dart_extensions) and filename not in excluded_files

def read_file_contents(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            return file.read()
    except UnicodeDecodeError:
        with open(file_path, 'r', encoding='iso-8859-1') as file:
            return file.read()
    except Exception as e:
        return f"Error reading file: {str(e)}"

def write_project_contents_to_file(project_path, folder_list, output_file):
    with open(output_file, 'w', encoding='utf-8') as f:
        for folder in folder_list:
            folder_path = os.path.join(project_path, folder)
            if not os.path.exists(folder_path):
                f.write(f"### Folder not found: {folder}\n\n")
                continue

            for root, dirs, files in os.walk(folder_path):
                if 'build' in dirs:
                    dirs.remove('build')  # don't visit build directories
                if '.dart_tool' in dirs:
                    dirs.remove('.dart_tool')  # don't visit .dart_tool directories
                
                for file in files:
                    if is_dart_file(file):
                        file_path = os.path.join(root, file)
                        relative_path = os.path.relpath(file_path, project_path)
                        f.write(f"### File: {relative_path}\n\n")
                        f.write(read_file_contents(file_path))
                        f.write("\n\n")

# Assuming the script is run from the root of your Dart project
project_path = os.getcwd()
output_file = 'project_code_contents.txt'

# Define the list of folders to read
folders_to_read = [
    # Add your folder paths here, relative to the project root
    # For example:
    # 'lib',
    # 'test',
    'lib',

]

write_project_contents_to_file(project_path, folders_to_read, output_file)
print(f"Contents of files in specified folders have been written to {output_file}")