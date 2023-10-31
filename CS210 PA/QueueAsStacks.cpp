#include <iostream>

using namespace std;

// Data Class : Holds all the data that goes inside the Node
class PrintItem {
public:
    float fileSize;
    string fileName;
    PrintItem(float fileSize, string fileName) {
        this->fileSize = fileSize;
        this->fileName = fileName;
    }
    void print() {
        cout << fileSize << " " << endl;
        cout << fileName << " " << endl;
    }
};

// Node Class : Node for the LinkedList
template <typename T> class Node {
public:
    T *data;
    Node<T> *nextNode;

    Node(T *data) {
        this->data = data;
        nextNode = nullptr;
    }
    void print() { data->print(); }
};

//LinkedList Class : Container for Nodes
template <typename T> class LLStack {
private:
    Node<T> *top;
    int stackSize;
    const int MAXITEMS = 10;

public:
// Constructor
    LLStack() {
        top = nullptr;
        stackSize = 0;
    }

    LLStack(T* data) {
        top = new Node<T>(data);
        stackSize = 1;
    }

//Destructor
    ~LLStack() {
        while (!isEmpty()) {
            pop();
        }
    }

    bool isFull() {
        return stackSize == MAXITEMS;
    }

    bool isEmpty() {
        return stackSize == 0;
    }


    void push(T *value) {
    if (isFull())
        return;
        Node<T> *newNode = new Node<T>(value);
        if (stackSize == 0) {
            top = newNode;
        } else {
            newNode->nextNode = top;
            top = newNode;
        }
        stackSize++;
    }


    void pop() {
        if (isEmpty())
            return;
        Node<T> *temp = top;
        if (stackSize == 1) {
            top = nullptr;
        } else {
            top = top->nextNode;
        }
        delete temp;
        stackSize--;
    }

    T* peek() {
        return top->data;
    }

    void print() {
        LLStack *temp = new LLStack();
        while(!isEmpty()) {
            top->print();
            temp->push(peek());
            pop();
        }
        while(!temp->isEmpty()) {
            push(temp->peek());
            temp->pop();
        }
        delete temp;
    }

};
template <typename T> class StackQ {
private:
    LLStack<T>* enQStack;
    LLStack<T>* deQStack;
    int queueSize;
    const int QMAXITEMS = 10;

public:
    //Constructor
    StackQ() {
        enQStack = new LLStack<T>();
        deQStack = new LLStack<T>();
        queueSize = 0;
    }

    StackQ(T* value) {
        enQStack = new LLStack<T>(value);
        deQStack = new LLStack<T>();
        queueSize = 1;
    }

    //Destructor
    ~StackQ() {
        delete enQStack;
        delete deQStack;
    }

    bool isFull() {
        return queueSize == QMAXITEMS;
    }

    bool isEmpty() {
        return queueSize == 0;
    }


    void enqueue(T* value) {
        if(isFull()) {
            cout << "Queue is full!" << endl;
            return;
        }
        //update enQStack when an enqueue is needed
        stackTransferEnQ();
        enQStack->push(value);
        queueSize++;
        cout << "Success!" << endl;
    }

    void dequeue() {
        if (isEmpty()) {
            cout << "Queue is empty!" << endl;
            return;
        }
        //update deQStack when a dequeue is needed
        stackTransferDeQ();
        deQStack->pop();
        queueSize--;
        cout << "Success!" << endl;
    }

    T* peek() {
        //update deQStack when top value is needed
        stackTransferDeQ();
        if (deQStack->isEmpty()) {
            cout << "Queue is empty" << endl;
        } else {
            cout << "First in queue contains: " << endl;
            deQStack->peek()->print();
        }
        return deQStack->peek();
    }

    void print() {
        //update deQStack so nodes are all in order for printing
        stackTransferDeQ();
        deQStack->print();
    }

    void printStacks() {
        cout << "enQStack: " << endl;
        enQStack->print();
        cout << "deQStack: " << endl;
        deQStack->print();
    }

    int getSize() {
        return queueSize;
    }

private:
    //helper method, pushes nodes from enQ to deQ
    void stackTransferDeQ() {
        while(!enQStack->isEmpty()) {
            deQStack->push(enQStack->peek());
            enQStack->pop();
        }
    }

    //helper method, pushes nodes from deQ to enQ
    void stackTransferEnQ() {
        while(!deQStack->isEmpty()) {
            enQStack->push(deQStack->peek());
            deQStack->pop();
        }
    }

};



//Main Program

int main() {
    StackQ<PrintItem> *queue = new StackQ<PrintItem>;
    PrintItem *temp;
    string userInput = "a";
    char choice = 'x';
    float fileSize;
    string fileName;
    bool loop = true;

    // Calling operations on Linked List
    do {
        cout << "Please enter a valid character (a-g): " << endl;
        cout << "a. Add Item to print queue" << endl;
        cout << "b. Delete from print queue" << endl;
        cout << "c. Peek from the print queue" << endl;
        cout << "d. Display the print queue" << endl;
        cout << "e. Display print queue size" << endl;
        cout << "f. Display enQStack and deQStack" << endl;
        cout << "g. Exit" << endl;
        cout << "Enter input here: ";
        getline(cin, userInput);
        if(userInput.size() == 1) {
            choice = userInput.at(0);
        }
        else {
            choice = 'x';
        }
        switch (choice) {
            case 'a':
                cout << "Enter file name: ";
                getline(cin, fileName);
                cout << "Enter file size: ";
                getline(cin, userInput);
                try {
                    fileSize = stof(userInput);
                }
                catch (std::logic_error){
                    cout << "Invalid input, please try again" << endl;
                    break;
                }
                temp = new PrintItem(fileSize, fileName);
                queue->enqueue(temp);
                break;
            case 'b':
                queue->dequeue();
                break;
            case 'c':
                queue->peek();
                break;
            case 'd':
                queue->print();
                break;
            case 'e':
                cout << "Size: " << queue->getSize() << endl;
                break;
            case 'f':
                queue->printStacks();
                break;
            case 'g':
                loop = false;
                delete queue;
                break;
            default:
                cout << "Invalid input, please try again" << endl;
                break;
        }
    } while(loop);
    return 0;

}