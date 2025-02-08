#include <stdio.h>
#include <windows.h>

double size_of_files(int handle, wchar_t *parent_path);

int main()
{
	WIN32_FIND_DATA FindFileData;
	int handle;
	
	handle = FindFirstFile(L"C:\\Users\\Michal\\Downloads\\Folder\\*", &FindFileData);
	do {
		printf("%ls\n", FindFileData.cFileName);
	} while (FindNextFile(handle, &FindFileData));
	printf("\n");
	handle = FindFirstFile(L"C:\\Users\\Michal\\Downloads\\Folder\\*", &FindFileData);
	printf("Total: %f\n", size_of_files(handle, L"C:\\Users\\Michal\\Downloads\\Folder\\"));
	
	return 0;
}
