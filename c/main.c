//#include "params.h"
#include <math.h>
#include <string.h>
#include <stdlib.h>

// read in the parameters for the computation

// Global Domain Size
float Dx = 1;
float Dy = 1;
float Dz = 1;

// Number of nodes in each direction
#ifndef NX
#define NX 6
#endif
#ifndef NY
#define NY 6
#endif
#ifndef NZ
#define NZ 6
#endif

// Courant Number
float CFLN = 0.99;

// Simulation time
float simtime = 4e-7;

// sample location informatoin struct
typedef struct sampleLoc{
    char type[1];
    char dir[1];
    int i;
    int j;
    int k;
}sample;

// source information struct
typedef struct source{
    char type[1];
    char dir[1];
    int i1;
    int i2;
    int j1;
    int j2;
    int k1;
    int k2;
}source;




// source function
void sig(float *t, float *val)
{
	static float tw,to;
	tw = 1e-9;
    to = 5*tw;
	static float mag = 1;
	*val = -(mag*exp(-pow(((*t) - to),2)/pow(tw,2))*(2.0*(*t) - 2.0*to))/tw;
}

void Eupdate(float * Ex, float * Ey, float * Ez, float * Hx, float * Hy, float * Hz){
    for (i=0;i<NX;i++){
        for (j=0;j<NY,j++){
            for (k=0;k<NZ,k++){
                *Ex[i+NX*(j+NY*k)] = 
                    *Ex[i+NX*(j+NY*k)] + 
                    cExy * (Hz[i+NX*(j+NY*k)] - Hz[i+NX*(j+NY*k)]) -
                    cExz * (Hy[i+NX*(j+NY*k)] - Hy[i+NX*(j+NY*k)]);
            }
        }
    }//Flat[i + WIDTH * (j + DEPTH * k)] = Original[i, j, k]

}







int main(){
    //struct source src;

    // Set up the sampling
    //struct sampleLoc sample;
    struct sampleLoc sloc;
    strcpy(sloc.type, "E");
    strcpy(sloc.dir, "z");
    sloc.i = 3;
    sloc.j = 3;
    sloc.k = 3;

    // set up the source
    struct source src;
    strcpy(src.type, "J");
    strcpy(src.dir, "z");
    src.i1 = 2;
    src.i2 = 2;
    src.j1 = 2;
    src.j2 = 2;
    src.k1 = 2;
    src.k2 = 3;

    // material parameters and speed of light
    float mu_o = 1.2566370614e-6;
    float eps_o = 8.854187817e-12;
    float mu_r = 1;
    float eps_r = 1;
    float mu= mu_r * mu_o;
    float eps = eps_r * eps_o;
    float c = 1.0/sqrt(mu*eps);

    // discretization size computation
    float dx=Dx/(NX-1);
    float dy=Dy/(NY-1);
    float dz=Dz/(NZ-1);
    float dt=CFLN/(c*sqrt(pow(dx,-2)+pow(dy,-2)+pow(dz,-2)));

    int nt = floor(simtime/dt);

    // build the E and H space
    // E-field space
    float * Ex = malloc(NX*NY*NZ*sizeof(float));
    float * Ey = malloc(NX*NY*NZ*sizeof(float));
    float * Ez = malloc(NX*NY*NZ*sizeof(float));
    // H-field space
    float * Hx = malloc(NX*NY*NZ*sizeof(float));
    float * Hy = malloc(NX*NY*NZ*sizeof(float));
    float * Hz = malloc(NX*NY*NZ*sizeof(float));

    // build coefficient matrices
    // E-field coefficients
    float cExy = (dt/(eps*dy));
    float cExz = (dt/(eps*dz));
    float cEyx = (dt/(eps*dx));
    float cEyz = (dt/(eps*dz));
    float cEzx = (dt/(eps*dx));
    float cEzy = (dt/(eps*dy));
    // H-field coefficients
    float cHxy = (dt/(mu*dy));
    float cHxz = (dt/(mu*dz));
    float cHyx = (dt/(mu*dx));
    float cHyz = (dt/(mu*dz));
    float cHzx = (dt/(mu*dx));
    float cHzy = (dt/(mu*dy));

    // source coefficients
    float cJ = dt/eps;
    float cM = dt/mu;

    // build a sampling vector
    int N = pow(2, ceil(log(nt)/log(2)))*2;
    float * sample = malloc(N*sizeof(float));

    // time (make first update be at t=0)
    float t = -0.5*dt;

    int n;
    
    for(n=0 ; n<=nt*2 ; n++){
        // increment time by dt/2
        t=t+0.5*dt;
        // update the E-field
        Eupdate(&Ex,&Ey,&Ez,sizeof(Ex),sizeof(Ey),sizeof(Ez));
        // increment time by dt/2
        t=t+0.5*dt;
        // update the H-field
        Hupdate(&Hx,&Hy,&Hz,sizeof(Hx),sizeof(Hy),sizeof(Hz));
        // update the sample
        sample[n] = Ez[sloc.i + NX * (sloc.j + NY * sloc.k)];
        
        //Flat[x + WIDTH * (y + DEPTH * z)] = Original[x, y, z]
    }
    


    // Free the E and H field memory
    free(Ex);
    free(Ey);
    free(Ez);
    free(Hx);
    free(Hy);
    free(Hz);
    free(sample);
}
