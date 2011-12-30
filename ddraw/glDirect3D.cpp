// DXGL
// Copyright (C) 2011 William Feely

// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

#include "common.h"
#include "glDirect3D.h"
#include "glDirect3DDevice.h"
#include "glDirectDraw.h"
#include "glDirectDrawSurface.h"

glDirect3D7::glDirect3D7(glDirectDraw7 *glDD7)
{
	refcount=1;
	this->glDD7 = glDD7;
	glDD7->AddRef();
}

glDirect3D7::~glDirect3D7()
{
	glDD7->Release();
}

ULONG WINAPI glDirect3D7::AddRef()
{
	refcount++;
	return refcount;
}
ULONG WINAPI glDirect3D7::Release()
{
	ULONG ret;
	refcount--;
	ret = refcount;
	if(refcount == 0) delete this;
	return ret;
}

HRESULT WINAPI glDirect3D7::QueryInterface(REFIID riid, void** ppvObj)
{
	FIXME("glDirect3D7::QueryInterface: stub");
	return E_NOINTERFACE;
}


HRESULT WINAPI glDirect3D7::CreateDevice(REFCLSID rclsid, LPDIRECTDRAWSURFACE7 lpDDS, LPDIRECT3DDEVICE7 *lplpD3DDevice)
{
	FIXME("glDirect3D7::CreateDevice: stub");
	return DDERR_GENERIC;
}
HRESULT WINAPI glDirect3D7::CreateVertexBuffer(LPD3DVERTEXBUFFERDESC lpVBDesc, LPDIRECT3DVERTEXBUFFER7* lplpD3DVertexBuffer, DWORD dwFlags)
{
	FIXME("glDirect3D7::CreateVertexBuffer: stub");
	return DDERR_GENERIC;
}
HRESULT WINAPI glDirect3D7::EnumDevices(LPD3DENUMDEVICESCALLBACK7 lpEnumDevicesCallback, LPVOID lpUserArg)
{
	FIXME("glDirect3D7::EnumDevices: stub");
	return DDERR_GENERIC;
}
HRESULT WINAPI glDirect3D7::EnumZBufferFormats(REFCLSID riidDevice, LPD3DENUMPIXELFORMATSCALLBACK lpEnumCallback, LPVOID lpContext)
{
	FIXME("glDirect3D7::EnumZBufferFormats: stub");
	return DDERR_GENERIC;
}
HRESULT WINAPI glDirect3D7::EvictManagedTextures()
{
	FIXME("glDirect3D7::EvictManagedTextures: stub");
	return DDERR_GENERIC;
}