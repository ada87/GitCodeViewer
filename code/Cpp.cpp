#include <iostream>
#include <vector>
#include <string>
#include <memory>
#include <algorithm>
#include <map>
#include <thread>
#include <chrono>

// Namespace for the viewer application
namespace GitCodeViewer {

    // Enum for connection status
    enum class ConnectionStatus {
        Disconnected,
        Connecting,
        Connected,
        Error
    };

    // Base class for a File
    class FileNode {
    protected:
        std::string name;
        size_t size;

    public:
        FileNode(std::string n, size_t s) : name(n), size(s) {}
        virtual ~FileNode() = default;

        virtual void render() const = 0;
        
        std::string getName() const { return name; }
        size_t getSize() const { return size; }
    };

    // Derived class for Source Code
    class SourceFile : public FileNode {
        std::string language;

    public:
        SourceFile(std::string n, size_t s, std::string lang) 
            : FileNode(n, s), language(lang) {}

        void render() const override {
            std::cout << "[CODE] " << name << " (" << language 
                      << ") - " << size << " bytes" << std::endl;
            highlightSyntax();
        }

        void highlightSyntax() const {
            // Simulation of syntax highlighting logic
            std::cout << "       >> Applying colors for " << language << " syntax..." << std::endl;
        }
    };

    // Derived class for Image
    class ImageFile : public FileNode {
        int width, height;

    public:
        ImageFile(std::string n, size_t s, int w, int h) 
            : FileNode(n, s), width(w), height(h) {}

        void render() const override {
            std::cout << "[IMG]  " << name << " [" << width << "x" << height 
                      << "]" << std::endl;
        }
    };

    // Repository Manager Class
    class RepositoryManager {
    private:
        std::vector<std::shared_ptr<FileNode>> files;
        std::map<std::string, std::string> config;

    public:
        RepositoryManager() {
            config["theme"] = "dark";
            config["auto_fetch"] = "true";
        }

        void addFile(std::shared_ptr<FileNode> file) {
            files.push_back(file);
        }

        void listFiles() {
            std::cout << "\n--- Repository Content ---\n";
            for (const auto& file : files) {
                file->render();
            }
            std::cout << "--------------------------\n";
        }

        void sync() {
            std::cout << "\nSyncing with remote..." << std::endl;
            std::this_thread::sleep_for(std::chrono::milliseconds(500));
            
            // Sort files by size using lambda
            std::sort(files.begin(), files.end(), 
                [](const std::shared_ptr<FileNode>& a, const std::shared_ptr<FileNode>& b) {
                    return a->getSize() > b->getSize();
                });
                
            std::cout << "Sync complete. Files sorted by size.\n";
        }
    };
}

// Template function example
template<typename T>
T add(T a, T b) {
    return a + b;
}

int main() {
    using namespace GitCodeViewer;

    std::cout << "Starting C++ Engine for GitCodeViewer...\n";

    RepositoryManager repo;

    // Adding various files using smart pointers
    repo.addFile(std::make_shared<SourceFile>("main.cpp", 1024, "C++"));
    repo.addFile(std::make_shared<SourceFile>("utils.ts", 512, "TypeScript"));
    repo.addFile(std::make_shared<ImageFile>("logo.png", 20480, 512, 512));
    repo.addFile(std::make_shared<SourceFile>("styles.css", 200, "CSS"));

    repo.listFiles();

    // Multithreading simulation
    std::thread syncThread(&RepositoryManager::sync, &repo);
    
    std::cout << "Main thread doing other work...\n";
    for(int i=0; i<3; i++) {
        std::cout << "Working " << i << "...\n";
    }

    if (syncThread.joinable()) {
        syncThread.join();
    }

    repo.listFiles();

    std::cout << "\nEngine Shutdown. Memory cleaned up automatically via smart pointers.\n";
    
    return 0;
}